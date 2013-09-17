package net.pandoragames.far.ui.swing.menu;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.event.MenuEvent;
import javax.swing.event.MenuListener;

import net.pandoragames.far.ui.model.FileNamePattern;
import net.pandoragames.far.ui.model.FindForm;
import net.pandoragames.far.ui.model.MessageBox;
import net.pandoragames.far.ui.model.OperationType;
import net.pandoragames.far.ui.model.ProgressListener;
import net.pandoragames.far.ui.model.TargetFile;
import net.pandoragames.far.ui.swing.ComponentRepository;
import net.pandoragames.far.ui.swing.SwingConfig;
import net.pandoragames.far.ui.swing.component.FileSetTableModel;
import net.pandoragames.far.ui.swing.component.listener.ActionPreview;
import net.pandoragames.far.ui.swing.component.listener.ActionView;
import net.pandoragames.far.ui.swing.dialog.ExportFileListDialog;
import net.pandoragames.far.ui.swing.dialog.FileEditor;
import net.pandoragames.far.ui.swing.dialog.FileOperationDialog;
import net.pandoragames.far.ui.swing.dialog.InfoView;
import net.pandoragames.util.i18n.Localizer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * The "File" menu, containing basic file operations.
 * Most items will only be activated if at least one 
 * file is selected in the result list table.
 *
 * @author Olivier Wehner
 * <!-- copyright note -->
 */
public class FileMenu extends JMenu {

	private JFrame mainFrame;
	private SwingConfig config;
	private MessageBox errorSink;
	private FileSetTableModel tableModel;
	private FindForm findForm;
	private Log logger = LogFactory.getLog( FileMenu.class );

	// actions
	private ActionView viewAction;
	private ActionPreview previewAction;
	// menu items
	private JMenuItem export;
	private JMenuItem edit;
	private JMenuItem info;
	private JMenuItem rename;
	private JMenuItem copy;
	private JMenuItem treeCopy;
	private JMenuItem move;
	private JMenuItem delete;

	public FileMenu(ComponentRepository componentRepository, SwingConfig swingConfig) {
		super( swingConfig.getLocalizer().localize("menu.file") );
		tableModel = componentRepository.getTableModel();
		config = swingConfig;
		errorSink = componentRepository.getMessageBox();
		mainFrame = componentRepository.getRootWindow();
		findForm = componentRepository.getFindForm();
		viewAction = new ActionView( componentRepository, swingConfig);
		previewAction = new ActionPreview( componentRepository, swingConfig);
		init( config.getLocalizer(), componentRepository );
		this.addMenuListener( new FileMenuListener() );
		this.setMnemonic( config.getAccessKey("menu.file") );
	}
	
	private void init( final Localizer localizer, final ComponentRepository componentRepository) {
		//	Import
		JMenuItem importMenu = new JMenuItem( localizer.localize( "label.import" ) );
		importMenu.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JFileChooser fileChooser = new JFileChooser( config.getFileListExportDirectory() );
				fileChooser.setDialogTitle( localizer.localize("label.select-import-file") );
				fileChooser.setFileSelectionMode( JFileChooser.FILES_ONLY );
				int returnVal = fileChooser.showOpenDialog( FileMenu.this );
			    if( returnVal == JFileChooser.APPROVE_OPTION ) {
					Runnable fileImporter = new ImportAction(fileChooser.getSelectedFile(), localizer, componentRepository.getOperationCallBackListener());
			    	Thread thread = new Thread( fileImporter );
			    	thread.setDaemon( true );
			    	thread.start();
			    }
			}
		});
		this.add( importMenu );
		//	Export
		export = new JMenuItem( localizer.localize( "label.export" ) );
		export.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				ExportFileListDialog dialog = new ExportFileListDialog( mainFrame, tableModel, config );
				dialog.pack();
				dialog.setVisible( true );
			}
		});
		this.add( export );
		// seperator 
		this.addSeparator();
		//	Edit
		edit = new JMenuItem( localizer.localize( "label.edit" ) );
		edit.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				FileEditor editor = new FileEditor( mainFrame, 
						  tableModel.getSelectedRows().get(0), 
						  config);
				editor.pack();
				editor.setVisible( true );
			}
		});
		this.add( edit );
		//	View
		JMenuItem view = new JMenuItem( viewAction );
		this.add( view );
		//	Preview
		JMenuItem preview = new JMenuItem( previewAction );
		this.add( preview );
		//	Info
		info = new JMenuItem( localizer.localize( "label.info" ) );
		info.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				InfoView infoView = new InfoView( mainFrame, 
						  tableModel.getSelectedRows().get(0), 
						  config);
				infoView.pack();
				infoView.setVisible( true );
			}
		});
		this.add( info );
		// seperator 
		this.addSeparator();
		// copy
		copy = new JMenuItem( localizer.localize( "menu.copy" ) );
		copy.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				FileOperationDialog.copyDialog(	tableModel, 
													findForm,
													errorSink,
													config,
													mainFrame);
			}
		});
		this.add( copy );
		// tree copy
		treeCopy = new JMenuItem( localizer.localize( "menu.treeCopy" ) );
		treeCopy.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				FileOperationDialog.treeCopyDialog(tableModel, 
													findForm,
													errorSink,
													config,
													mainFrame);
			}
		});
		this.add( treeCopy );
		// move
		move = new JMenuItem( localizer.localize( "menu.move" ) );
		move.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				FileOperationDialog.moveDialog(	tableModel, 
													findForm,
													errorSink,
													config,
													mainFrame);
			}
		});
		this.add( move );
		// delete
		delete = new JMenuItem( localizer.localize( "menu.delete" ) );
		delete.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				FileOperationDialog.deleteDialog(tableModel, 
													findForm.getBaseDirectory(),
													errorSink,
													config,
													mainFrame);
			}
		});
		this.add( delete );
		// rename
		rename = new JMenuItem( localizer.localize( "menu.rename-dialog" ) );
		rename.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int rowIndex = tableModel.getRowIndex(tableModel.getSelectedRows().get(0));
				FileOperationDialog.renameDialog(rowIndex,
													tableModel,
													findForm, 
													errorSink,
													config,
													mainFrame);
			}
		});
		this.add( rename );
	}
	
	class FileMenuListener implements MenuListener {
		public void menuCanceled(MenuEvent e) {
		}
		public void menuDeselected(MenuEvent e) {
		}
		public void menuSelected(MenuEvent e) {
			export.setEnabled( tableModel.getRowCount() > 0 );
			boolean filesChecked = tableModel.getSelectedRowCount() > 0;
			copy.setEnabled( filesChecked );
			treeCopy.setEnabled( filesChecked );
			move.setEnabled( filesChecked );
			delete.setEnabled( filesChecked );
			edit.setEnabled( tableModel.getSelectedRowCount() == 1 );
			info.setEnabled( tableModel.getSelectedRowCount() == 1 );
			rename.setEnabled( tableModel.getSelectedRowCount() == 1 );
			if(tableModel.getSelectedRowCount() == 1) {
				viewAction.setSelectedFile( tableModel.getSelectedRows().get(0));
				previewAction.setSelectedFile( tableModel.getSelectedRows().get(0));
			} else {
				viewAction.setSelectedFile(null);
				previewAction.setSelectedFile(null);
			}
		}
	}
	
	class ImportAction implements Runnable {
		private File file;
		private Localizer localizer;
		private ProgressListener findProgressListener;
		public ImportAction(File importFile, Localizer loco, ProgressListener progressListener) {
			localizer = loco;
			findProgressListener = progressListener;
			file = importFile;
		}
		public void run() {
			logger.info("Importing file list from " + file.getPath());
	    	findProgressListener.operationStarted( OperationType.FIND );
	    	config.setFileListExportDirectory( file.getParentFile() );
			BufferedReader reader = null;
			List<String> result = new ArrayList<String>();
			try {
				reader = new BufferedReader(new InputStreamReader( new FileInputStream( file ), "UTF-8" ) );
				String line = null;
				int lineCount = 0;
				do {
					line = reader.readLine();
					if( line != null ) {
						line = line.trim();
						if( line.length() > 0 ) {
							lineCount++;
							result.add( line );
						}
						findProgressListener.operationProgressed(lineCount, 0, OperationType.FIND);
					}
				} while( line != null );
				List<TargetFile> importList = new ArrayList<TargetFile>();
				File basedir = null;
				int filesFound = 0;
				int brokenPathCount = 0;
				Set<String> duplicateCheck = new HashSet<String>();
				for(String path : result) {
					// TODO: check win/x path root
					// TODO: check for mixed drive letters on win
					File nextFile = new File( path );
					if(! nextFile.isDirectory() ) {
						TargetFile next = new TargetFile( nextFile );
						if( nextFile.isFile() ) {
							// duplicates are silently ignored
							if(! duplicateCheck.contains(path) ) {
								duplicateCheck.add( path );
								filesFound ++;
								if(basedir == null) {
									basedir = nextFile.getParentFile();
								} else {
									while( basedir != null && ! path.startsWith( basedir.getPath() )) {
										basedir = basedir.getParentFile();
									}
									if( basedir == null ) basedir = File.listRoots()[0];
								}
								importList.add( next );
							}
						} else if (nextFile.getParent() != null ) {  // not an existing file - possibly deleted
							next.error( localizer.localize("message.file-not-found") );
							next.setSelected( false );
							importList.add( next );
						} else {	// most probably no file at all but ordinary text
							logger.warn("Unreadable line in file import list: <<" + path + ">>" );
							brokenPathCount++;
						}
						findProgressListener.operationProgressed(importList.size(), lineCount, OperationType.FIND);
					}
				}
				logger.debug(importList.size() + " files from " + lineCount + " lines imported, " + filesFound + " files found");
				if( basedir != null && filesFound > 0 ) {
					FindForm inferedForm = config.getDefaultFindForm();
					inferedForm.setBaseDirectory( basedir );
					inferedForm.setFileNamePattern( new FileNamePattern("") );
					findForm.update( inferedForm );
					tableModel.setFileList( importList , basedir );
					// write to message sink AFTER updating the model to avoid clear() erasing the message
					if(brokenPathCount == 0 && filesFound == lineCount ) {
						errorSink.info(localizer.localize("message.import-ok", new Object[]{ file.getName(), Integer.valueOf(filesFound)} ));
					} else if(brokenPathCount == 0) {
						errorSink.info(localizer.localize("message.import-partly", new Object[]{ file.getName(), Integer.valueOf(filesFound), Integer.valueOf(lineCount)} ));
					} else {
						errorSink.error(localizer.localize("message.import-with-errors", new Object[]{ Integer.valueOf(filesFound), Integer.valueOf(lineCount - brokenPathCount - filesFound), Integer.valueOf(brokenPathCount), Integer.valueOf(lineCount)} ));
					}
				} else if(filesFound == 0){
					logger.info("No existing files found");
					errorSink.error(localizer.localize("message.no-file-reference" ));
				} else {	// basedir == null
					logger.info("No common base dir found");
					errorSink.error(localizer.localize("message.no-common-base-directory" ));					
				}
				findProgressListener.operationTerminated( OperationType.FIND );
			} catch(IOException iox) {
				errorSink.error(localizer.localize("message.file-not-loaded", file.getPath() ));
				logger.error("IOException reading " + file.getPath() + ": " + iox.getMessage());
			} finally {
				if(reader != null) try { reader.close(); } catch(IOException ix) {/* ignore me */}
			}
	    }

	}

}
