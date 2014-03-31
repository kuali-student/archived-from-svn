/*
 * Copyright 2014 The Kuali Foundation
 * 
 * Licensed under the Educational Community License, Version 1.0 (the
 * "License"); you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.opensource.org/licenses/ecl1.php
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.kuali.student.git.importer;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;

import org.eclipse.jgit.api.GarbageCollectCommand;
import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.errors.GitAPIException;
import org.eclipse.jgit.lib.CommitBuilder;
import org.eclipse.jgit.lib.Constants;
import org.eclipse.jgit.lib.ObjectId;
import org.eclipse.jgit.lib.ObjectInserter;
import org.eclipse.jgit.lib.PersonIdent;
import org.eclipse.jgit.lib.Ref;
import org.eclipse.jgit.lib.RefUpdate;
import org.eclipse.jgit.lib.RefUpdate.Result;
import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.revwalk.RevCommit;
import org.eclipse.jgit.revwalk.RevWalk;
import org.joda.time.DateTime;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.kuali.student.git.model.BranchMergeInfo;
import org.kuali.student.git.model.BranchRangeDataProviderImpl;
import org.kuali.student.git.model.GitBranchData;
import org.kuali.student.git.model.GitCommitData;
import org.kuali.student.git.model.NodeProcessor;
import org.kuali.student.git.model.SvnRevisionMapper;
import org.kuali.student.git.model.branch.BranchDetector;
import org.kuali.student.git.model.exceptions.VetoBranchException;
import org.kuali.student.git.tools.SvnMergeInfoUtils;
import org.kuali.student.git.utils.GitBranchUtils;
import org.kuali.student.svn.tools.AbstractParseOptions;
import org.kuali.student.svn.tools.merge.model.BranchData;
import org.kuali.student.svn.tools.model.INodeFilter;
import org.kuali.student.svn.tools.model.ReadLineData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Kuali Student Team
 *
 */
public class GitImporterParseOptions extends AbstractParseOptions {

	private static final Logger log = LoggerFactory.getLogger(GitImporterParseOptions.class);
	
		private GitCommitData commitData = null;

		private long currentRevision = 0;

		private SvnRevisionMapper revisionMapper;

		private String repositoryUUID;
		
		private final Map<String, GitBranchData> knownBranchMap = new LinkedHashMap<String, GitBranchData>();
		private NodeProcessor nodeProcessor;

		private PrintWriter vetoLog;

		private Repository repo;

		private PrintWriter copyFromSkippedLog;

		private boolean printGitSvnIds;

		private String repositoryBaseUrl;

		private boolean gcEnabled;

		private BranchDetector branchDetector;

		private String externalGitCommandPath;

		private PrintWriter blobLog;
		
		/**
		 * @param repo 
		 * @param vetoLog 
		 * @param copyFromSkippedLog 
		 * @param branchDetector 
		 * @param gcEnabled 
		 * @param repositoryUUID2 
		 * 
		 */
		public GitImporterParseOptions(Repository repo, PrintWriter vetoLog, PrintWriter copyFromSkippedLog, PrintWriter blobLog, boolean printGitSvnIds, String repositoryBaseUrl, String repositoryUUID, BranchDetector branchDetector, boolean gcEnabled, String nativeGitCommandPath) {
		
			this.repo = repo;
			this.vetoLog = vetoLog;
			this.copyFromSkippedLog = copyFromSkippedLog;
			this.blobLog = blobLog;
			this.printGitSvnIds = printGitSvnIds;
			this.repositoryBaseUrl = repositoryBaseUrl;
			this.repositoryUUID = repositoryUUID;
			this.branchDetector = branchDetector;
			this.externalGitCommandPath = nativeGitCommandPath;
			this.gcEnabled = gcEnabled;
			
			revisionMapper = new SvnRevisionMapper(repo);
			nodeProcessor = new NodeProcessor(knownBranchMap, vetoLog, copyFromSkippedLog, blobLog, repo, revisionMapper, this, branchDetector, repositoryBaseUrl);
			
		}
		
		
		/**
		 * @return the inputStream
		 */
		public InputStream getInputStream() {
			return super.inputStream;
		}

		/*
		 * (non-Javadoc)
		 * 
		 * @see
		 * org.kuali.student.svn.tools.AbstractParseOptions#
		 * onStreamEnd
		 * (org.kuali.student.svn.tools.model.ReadLineData)
		 */
		@Override
		public void onStreamEnd(ReadLineData lineData) {
			// at the end of the stream flush and branch commits
			// that are pending.

			flushPendingBranchCommits();
			
			try {
				revisionMapper.shutdown();
			} catch (IOException e) {
				log.error("failed to shutdown revision mapper: ", e);
			}

		}

		/*
		 * The revision comes before the file content so only
		 * the second call per file and onward is relevant.
		 */
		@Override
		public void onRevisionContentLength(
				long currentRevision, long contentLength,
				long propContentLength, ReadLineData lineData) {

			// flush logs for the last revision

			blobLog.flush();
			copyFromSkippedLog.flush();
			vetoLog.flush();
			
			// for any branch with a blob added create a git commit object pointing at the git tree for the change.
			flushPendingBranchCommits();
			
		if (gcEnabled && this.currentRevision != 0 && this.currentRevision % 500 == 0) {
			// every five hundred revisions garbage collect the repository to
			// keep it fast
			log.info("Garbage collecting git repository");

			if (externalGitCommandPath != null) {
				try {
					String command = String.format("%s --git-dir %s gc",
							externalGitCommandPath, repo.getDirectory()
									.getAbsolutePath());

					log.info("invoking external garbage collection : " + command);
					
					Process p = Runtime.getRuntime().exec(command);

					p.waitFor();
					
				} catch (IOException e) {

				} catch (InterruptedException e) {

				}
			}

			else {
				try {
					GarbageCollectCommand gc = new Git(repo).gc();

					// should not matter but anything loose can be collected.
					gc.setExpire(new Date());

					gc.call();

				} catch (GitAPIException e) {

				}
			}
		}
			
//			if (gcEnabled && this.currentRevision != 0 && this.currentRevision % 10000 == 0) {
//				// repack the revision map file every 10000 revs
//				try {
//					revisionMapper.repackMapFile();
//				} catch (IOException e) {
//					throw new RuntimeException("failed to repack revision mapper", e);
//				}
//			}
			
			this.currentRevision = currentRevision;

			log.info("starting on Revision: " + currentRevision);

			// at this point we should be able to read
			// propContentLength and parse out the

			try {
				Map<String, String> revisionProperties = org.kuali.student.common.io.IOUtils
						.extractRevisionProperties(inputStream,
								propContentLength,
								contentLength);

				// read out the author and commit message
				String author = revisionProperties
						.get("svn:author");

				String commitDate = revisionProperties
						.get("svn:date");

				String commitMessage = revisionProperties
						.get("svn:log");

				String userName = author;

				if (userName == null)
					userName = "unknown";

				String emailAddress = userName
						+ "@kuali.org";

				Date actualCommitDate = convertDate(commitDate);

				// TODO parse out the time zone correctly.

				;
				
				commitData = new GitCommitData(new PersonIdent(
						userName, emailAddress, actualCommitDate,
						TimeZone.getTimeZone("EDT")), commitMessage);
				
				nodeProcessor.setCommitData (commitData);

				// also consider copyfrom or other details that
				// suggest a merge at this point.

			} catch (Exception e) {
				throw new RuntimeException(
						"onRevisionContentLength failed to read revision properties.",
						e);
			}

		}

		private void flushPendingBranchCommits() {

			try {
				
				RevWalk rw = new RevWalk(repo);
				
				for (Map.Entry<String, GitBranchData> entry : knownBranchMap
						.entrySet()) {
					
					String branchName = entry.getKey();
					GitBranchData data = entry.getValue();

					if (data.getBlobsAdded() == 0 && !data.isBlobsDeleted() && !data.isCreated()) {
						
						/*
						 * Directory changes can cause a branch data object
						 * to be created but we really only want to save it if blob's have been added or deleted.
						 */
						log.info("skipped commit on branch " + branchName + " at " + currentRevision + " due to no blob changes present.");
						continue;
					}
					
					// only flush if the branch has data to
					// commit for the current revision
					log.debug("branch = " + branchName
							+ " has data to commit");

					// create the commit
					CommitBuilder commitBuilder = new CommitBuilder();

					ObjectInserter inserter  = repo
							.newObjectInserter();

					// create the tree
					ObjectId treeId = null;
					
					ObjectId parentId = data.getParentId();
					
					if (data.getBlobsAdded() == 0 && parentId != null) {
						
						RevCommit parentCommit = rw.parseCommit(parentId);
						
						treeId = parentCommit.getTree().getId();
						
						log.debug("reuse parent tree id = " + treeId.name());
					}
					else {
						treeId = data
							.buildTree(inserter);
						
						log.debug("create new tree id = " + treeId.name());
					}
					
					

					commitBuilder.setTreeId(treeId);

					Set<ObjectId> parentSet = new HashSet<ObjectId>();
					
					if (parentId != null)
						parentSet.add(parentId);
					
					parentSet.addAll(computeSvnMergeInfoParentIds(currentRevision, data));
					
					parentSet.addAll(data.getMergeParentIds());
					
					commitBuilder.setParentIds(Arrays.asList(parentSet.toArray(new ObjectId[] {})));

					commitBuilder.setAuthor(commitData.getPersonIdent());

					commitBuilder.setCommitter(commitData.getPersonIdent());
					
					if (printGitSvnIds) {
						StringBuilder commitMessageBuilder = new StringBuilder();
						
						commitMessageBuilder.append(commitData.getCommitMessage());
						
						appendGitSvnId(commitMessageBuilder, repositoryBaseUrl, data.getBranchPath(), currentRevision, repositoryUUID);
						
						commitBuilder.setMessage(commitMessageBuilder.toString());
					}
					else {
						// just the commit message
						commitBuilder.setMessage(commitData.getCommitMessage());
					}
					

					ObjectId commitId = inserter
							.insert(commitBuilder);

					inserter.flush();

					inserter.release();

					// post commit update the branch reference.

					// create the branch in git

					String fullBranchNameReference = Constants.R_HEADS
							+ data.getBranchName();

					if (fullBranchNameReference.length() >= GitBranchUtils.FILE_SYSTEM_NAME_LIMIT) {
						
						fullBranchNameReference = Constants.R_HEADS + revisionMapper.storeLargeBranchName(fullBranchNameReference, currentRevision);
					}
					
					RefUpdate update = repo
							.updateRef(fullBranchNameReference);

					update.setNewObjectId(commitId);
					update.setRefLogMessage(
							"created new branch "
									+ fullBranchNameReference,
							true);

					if (repo.getRefDatabase().isNameConflicting(fullBranchNameReference)) {
						log.warn(fullBranchNameReference  + " is conflicting with an existing reference.");
					}
					
					Result result = update.forceUpdate();

					if (result == null
							|| !(result.equals(Result.NEW)
									|| result
											.equals(Result.FORCED) || result
										.equals(Result.FAST_FORWARD))) {
						throw new RuntimeException(
								"failed to create new branch: "
										+ fullBranchNameReference);
					}
					Ref ref = repo.getRef(fullBranchNameReference);

					ObjectId refObjectId = ref.getObjectId();

					log.info(String.format("updated %s to %s",
							fullBranchNameReference,
							commitId.name()));

					if (!commitId.equals(refObjectId)) {
						log.warn("failed to update ref for "
								+ branchName);
					}

					List<BranchMergeInfo> accumulatedMergeData = data.getAccumulatedBranchMergeData();

					if (accumulatedMergeData.size() > 0)
						revisionMapper.createMergeData(currentRevision, data.getBranchPath(), accumulatedMergeData);
					
				}

				Map<String, Ref> headRefs = repo.getRefDatabase().getRefs(Constants.R_HEADS);
				
				List<Ref> refs = new ArrayList<Ref>(headRefs.values());

				revisionMapper.createRevisionMap(
						currentRevision, refs);
				
				knownBranchMap.clear();
				
				rw.release();

			} catch (IOException e) {
				throw new RuntimeException(
						"flushPendingBranchCommits failed on rev = "
								+ currentRevision, e);
			}
		}

		private Set<ObjectId> computeSvnMergeInfoParentIds(
				long currentRevision, GitBranchData data) {
		
			Set<ObjectId>mergeInfoParentIds = new HashSet<>();
			
			try {
				
				List<BranchMergeInfo> currentMergeInfo = revisionMapper.getMergeBranches(currentRevision, data.getBranchPath());
				
				List<BranchMergeInfo> sourceMergeInfo = revisionMapper.getMergeBranches(currentRevision-1, data.getBranchPath());
				
				if (currentMergeInfo == null || (sourceMergeInfo == null && currentMergeInfo == null))
					return mergeInfoParentIds; // if there is no merge info then return no parent commits.
				
				List<BranchMergeInfo> deltas = null;
				
				if (sourceMergeInfo == null && currentMergeInfo != null) {
					// there was no merge info but now there is so take everything in current merge info
					deltas = currentMergeInfo;
				}
				else {
					// source and current exist so compute the difference
					deltas = SvnMergeInfoUtils.computeDifference(sourceMergeInfo, currentMergeInfo);
				}
				
				RevWalk rw = new RevWalk(repo);
				
				SvnMergeInfoUtils.consolidateConsecutiveRanges (new BranchRangeDataProviderImpl(revisionMapper, rw), branchDetector, revisionMapper, deltas);
				
				rw.release();
				
				for (BranchMergeInfo delta : deltas) {
					
					String mergedBranchPath = delta.getBranchName();
					
					if (mergedBranchPath.equals(data.getBranchPath()))
						continue; // don't apply self merge revisions.
					
					try {
						BranchData mergedBranchData = branchDetector.parseBranch(0L, mergedBranchPath);
						
						for (Long mergedRevision : delta.getMergedRevisions()) {
							
							ObjectId mergeBranchHeadId = revisionMapper.getRevisionBranchHead(mergedRevision, GitBranchUtils.getCanonicalBranchName(mergedBranchData.getBranchPath(), mergedRevision, revisionMapper));
							
							if (mergeBranchHeadId == null) {
								log.warn(String.format("failed to merge %s into %s at revision %d", mergedBranchPath, data.getBranchName(), mergedRevision));
							}
							else {
								mergeInfoParentIds.add(mergeBranchHeadId);
								log.info(String.format("merged %s at revision %d into branch %s", mergedBranchPath, mergedRevision, data.getBranchName()));
							}
						}
					} catch (VetoBranchException e) {
						// skip over if the path is not a known branch
						continue;
					}
					
				}
				
			} catch (IOException e) {
				
				// fall through
			}
			
			
			
			return mergeInfoParentIds;
			
		}


		


		/*
		 * Constructs a git-svn-id that looks the way git-svn expects.
		 * 
		 * This is useful for debugging purposes and  may allow git-svn to work with the converted
		 * repository at a later time (untested).
		 */
		private void appendGitSvnId(
				StringBuilder commitMessageBuilder,
				String svnRepositoryBaseUrl, String branchPath,
				long currentRevision, String repositoryUUID) {
			
			commitMessageBuilder.append("\n\ngit-svn-id: ");
			commitMessageBuilder.append(svnRepositoryBaseUrl);
			
			if (!svnRepositoryBaseUrl.endsWith("/")) {
				commitMessageBuilder.append("/");
			}
				
			commitMessageBuilder.append(branchPath);
			
			commitMessageBuilder.append("@");
			commitMessageBuilder.append(currentRevision);
			commitMessageBuilder.append(" ");
			commitMessageBuilder.append(repositoryUUID);
			
			
		}

		private static DateTimeFormatter SvnDumpDateFormatter = DateTimeFormat
				.forPattern("YYYY-MM-dd'T'HH:mm:ss.SSSSSS'Z'");

		private Date convertDate(String date) {

			DateTime dt = SvnDumpDateFormatter
					.parseDateTime(date);

			LocalDateTime ldt = new LocalDateTime(dt);

			Date d = ldt.toDate();

			return d;
		}

		
		
		/* (non-Javadoc)
		 * @see org.kuali.student.svn.tools.AbstractParseOptions#onUUID(org.kuali.student.svn.tools.model.ReadLineData)
		 */
		@Override
		public void onUUID(ReadLineData lineData) {
			
			try {
				revisionMapper.initialize();
			} catch (IOException e) {
				throw new RuntimeException("revision mapper failed to initialize", e);
			}
			
			if (repositoryUUID == null) {
				// if not specified by the user read it from the dump stream.
				String line = lineData.getLine();
				
				String parts[] = line.split(":");
				
				this.repositoryUUID = parts[1].trim();
				
			}
			
		}

		/* (non-Javadoc)
		 * @see org.kuali.student.svn.tools.AbstractParseOptions#onAfterNode(long, java.lang.String, java.util.Map, org.kuali.student.svn.tools.model.INodeFilter)
		 */
		@Override
		public void onAfterNode(long currentRevision,
				String path,
				Map<String, String> nodeProperties,
				INodeFilter nodeFilter) {
			
			try {
				nodeProcessor.processNode(path, currentRevision, nodeProperties);
			} catch (IOException e) {
				throw new RuntimeException("onAfterNode: exception", e);
			} catch (VetoBranchException e) {
				vetoLog.println(String.format("onAfterNode: vetoed %s at %d", path, currentRevision));
			}

		}

		

		
		/*
		 * (non-Javadoc)
		 * 
		 * @see
		 * org.kuali.student.svn.tools.AbstractParseOptions#
		 * onNodeContentLength(long, java.lang.String, long,
		 * long, java.util.Map,
		 * org.kuali.student.svn.tools.model.INodeFilter)
		 */
		@Override
		public void onNodeContentLength(long currentRevision,
				String path, long contentLength,
				long propContentLength,
				Map<String, String> nodeProperties,
				INodeFilter nodeFilter) {

			
			try {
				nodeProcessor.processNode(path, currentRevision, nodeProperties);
			} catch (IOException e) {
				throw new RuntimeException("onNodeContentLength: exception", e);
			} catch (VetoBranchException e) {
				vetoLog.println(String.format("onNodeContentLength: vetoed %s at %d", path, currentRevision));
			}
			
		}

		

	

}
