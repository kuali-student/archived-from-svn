/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kuali.student.service.remote.impl;

import java.util.List;
import org.kuali.rice.core.api.criteria.QueryByCriteria;
import org.kuali.student.r2.common.dto.ContextInfo;
import org.kuali.student.r2.common.dto.StatusInfo;
import org.kuali.student.r2.common.dto.ValidationResultInfo;
import org.kuali.student.r2.common.exceptions.AlreadyExistsException;
import org.kuali.student.r2.common.exceptions.DataValidationErrorException;
import org.kuali.student.r2.common.exceptions.DependentObjectsExistException;
import org.kuali.student.r2.common.exceptions.DoesNotExistException;
import org.kuali.student.r2.common.exceptions.InvalidParameterException;
import org.kuali.student.r2.common.exceptions.MissingParameterException;
import org.kuali.student.r2.common.exceptions.OperationFailedException;
import org.kuali.student.r2.common.exceptions.PermissionDeniedException;
import org.kuali.student.r2.common.exceptions.ReadOnlyException;
import org.kuali.student.r2.common.exceptions.UnsupportedActionException;
import org.kuali.student.r2.common.exceptions.VersionMismatchException;
import org.kuali.student.r2.core.class1.type.dto.TypeInfo;
import org.kuali.student.r2.core.search.dto.SearchRequestInfo;
import org.kuali.student.r2.core.search.dto.SearchResultInfo;
import org.kuali.student.r2.lum.lo.dto.LoCategoryInfo;
import org.kuali.student.r2.lum.lo.dto.LoInfo;
import org.kuali.student.r2.lum.lo.dto.LoLoRelationInfo;
import org.kuali.student.r2.lum.lo.dto.LoRepositoryInfo;
import org.kuali.student.r2.lum.lo.service.LearningObjectiveService;

/**
 *
 * @author nwright
 */
public class LearningObjectiveServiceDecorator implements LearningObjectiveService {

    private LearningObjectiveService nextDecorator;

    public LearningObjectiveService getNextDecorator() {
        return nextDecorator;
    }

    public void setNextDecorator(LearningObjectiveService nextDecorator) {
        this.nextDecorator = nextDecorator;
    }

    @Override
    public LoRepositoryInfo getLoRepository(String loRepositoryKey, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoRepository(loRepositoryKey, contextInfo);
    }

    @Override
    public List<LoRepositoryInfo> getLoRepositoriesByKeys(List<String> loRepositoryKeys, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoRepositoriesByKeys(loRepositoryKeys, contextInfo);
    }

    @Override
    public List<LoRepositoryInfo> getLoRepositories(ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoRepositories(contextInfo);
    }

    @Override
    public List<String> getLoRepositoryKeysByType(String loRepositoryTypeKey, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoRepositoryKeysByType(loRepositoryTypeKey, contextInfo);
    }

    @Override
    public List<String> searchForLoRepositoryKeys(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().searchForLoRepositoryKeys(criteria, contextInfo);
    }

    @Override
    public List<LoRepositoryInfo> searchForLoRepositories(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().searchForLoRepositories(criteria, contextInfo);
    }

    @Override
    public List<ValidationResultInfo> validateLoRepository(String validationTypeKey, String loRepositoryTypeKey, LoRepositoryInfo loRepositoryInfo, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().validateLoRepository(validationTypeKey, loRepositoryTypeKey, loRepositoryInfo, contextInfo);
    }

    @Override
    public LoRepositoryInfo createLoRepository(String loRepositoryKey, String loRepositoryTypeKey, LoRepositoryInfo loRepositoryInfo, ContextInfo contextInfo) throws AlreadyExistsException, DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException {
        return getNextDecorator ().createLoRepository(loRepositoryKey, loRepositoryTypeKey, loRepositoryInfo, contextInfo);
    }

    @Override
    public LoRepositoryInfo updateLoRepository(String loRepositoryKey, LoRepositoryInfo loRepositoryInfo, ContextInfo contextInfo) throws DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        return getNextDecorator ().updateLoRepository(loRepositoryKey, loRepositoryInfo, contextInfo);
    }

    @Override
    public StatusInfo deleteLoRepository(String loRepositoryKey, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().deleteLoRepository(loRepositoryKey, contextInfo);
    }

    @Override
    public LoInfo getLo(String loId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLo(loId, contextInfo);
    }

    @Override
    public List<LoInfo> getLosByIds(List<String> loIds, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLosByIds(loIds, contextInfo);
    }

    @Override
    public List<String> getLoIdsByType(String loTypeKey, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoIdsByType(loTypeKey, contextInfo);
    }

    @Override
    public List<LoInfo> getLosByLoRepository(String loRepositoryKey, String loTypeKey, String loStateKey, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLosByLoRepository(loRepositoryKey, loTypeKey, loStateKey, contextInfo);
    }

    @Override
    public List<LoInfo> getLosByLoCategory(String loCategoryId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLosByLoCategory(loCategoryId, contextInfo);
    }

    @Override
    public List<LoInfo> getLosByRelatedLoId(String relatedLoId, String loLoRelationTypeKey, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLosByRelatedLoId(relatedLoId, loLoRelationTypeKey, contextInfo);
    }

    @Override
    public List<LoInfo> getRelatedLosByLoId(String loId, String loLoRelationTypeKey, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getRelatedLosByLoId(loId, loLoRelationTypeKey, contextInfo);
    }

    @Override
    public List<String> searchForLoIds(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().searchForLoIds(criteria, contextInfo);
    }

    @Override
    public List<LoInfo> searchForLos(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().searchForLos(criteria, contextInfo);
    }

    @Override
    public List<ValidationResultInfo> validateLo(String validationTypeKey, LoInfo loInfo, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().validateLo(validationTypeKey, loInfo, contextInfo);
    }

    @Override
    public LoInfo createLo(String repositoryId, String loType, LoInfo loInfo, ContextInfo contextInfo) throws DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException {
        return getNextDecorator ().createLo(repositoryId, loType, loInfo, contextInfo);
    }

    @Override
    public LoInfo updateLo(String loId, LoInfo loInfo, ContextInfo contextInfo) throws DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        return getNextDecorator ().updateLo(loId, loInfo, contextInfo);
    }

    @Override
    public StatusInfo deleteLo(String loId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, DependentObjectsExistException {
        return getNextDecorator ().deleteLo(loId, contextInfo);
    }

    @Override
    public LoCategoryInfo getLoCategory(String loCategoryId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoCategory(loCategoryId, contextInfo);
    }

    @Override
    public List<LoCategoryInfo> getLoCategoriesByIds(List<String> loCategoryIds, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoCategoriesByIds(loCategoryIds, contextInfo);
    }

    @Override
    public List<LoCategoryInfo> getLoCategoriesByLoRepository(String loRepositoryKey, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoCategoriesByLoRepository(loRepositoryKey, contextInfo);
    }

    @Override
    public List<String> getLoCategoryIdsByType(String loCategoryTypeKey, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoCategoryIdsByType(loCategoryTypeKey, contextInfo);
    }

    @Override
    public List<LoCategoryInfo> getLoCategoriesByLo(String loId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoCategoriesByLo(loId, contextInfo);
    }

    @Override
    public List<String> searchForLoCategoryIds(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().searchForLoCategoryIds(criteria, contextInfo);
    }

    @Override
    public List<LoCategoryInfo> searchForLoCategories(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().searchForLoCategories(criteria, contextInfo);
    }

    @Override
    public List<ValidationResultInfo> validateLoCategory(String validationTypeKey, LoCategoryInfo loCategoryInfo, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().validateLoCategory(validationTypeKey, loCategoryInfo, contextInfo);
    }

    @Override
    public LoCategoryInfo createLoCategory(String loCategoryTypeKey, LoCategoryInfo loCategoryInfo, ContextInfo contextInfo) throws DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException {
        return getNextDecorator ().createLoCategory(loCategoryTypeKey, loCategoryInfo, contextInfo);
    }

    @Override
    public LoCategoryInfo updateLoCategory(String loCategoryId, LoCategoryInfo loCategoryInfo, ContextInfo contextInfo) throws DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        return getNextDecorator ().updateLoCategory(loCategoryId, loCategoryInfo, contextInfo);
    }

    @Override
    public StatusInfo deleteLoCategory(String loCategoryId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, DependentObjectsExistException {
        return getNextDecorator ().deleteLoCategory(loCategoryId, contextInfo);
    }

    @Override
    public StatusInfo deleteLoCategoryByLo(String loId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().deleteLoCategoryByLo(loId, contextInfo);
    }

    @Override
    public StatusInfo addLoCategoryToLo(String loCategoryId, String loId, ContextInfo contextInfo) throws AlreadyExistsException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, UnsupportedActionException {
        return getNextDecorator ().addLoCategoryToLo(loCategoryId, loId, contextInfo);
    }

    @Override
    public StatusInfo removeLoCategoryFromLo(String loCategoryId, String loId, ContextInfo contextInfo) throws AlreadyExistsException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, UnsupportedActionException {
        return getNextDecorator ().removeLoCategoryFromLo(loCategoryId, loId, contextInfo);
    }

    @Override
    public LoLoRelationInfo getLoLoRelation(String loLoRelationId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoLoRelation(loLoRelationId, contextInfo);
    }

    @Override
    public List<LoLoRelationInfo> getLoLoRelationsByIds(List<String> loLoRelationIds, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoLoRelationsByIds(loLoRelationIds, contextInfo);
    }

    @Override
    public List<String> getLoLoRelationIdsByType(String loLoRelationTypeKey, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoLoRelationIdsByType(loLoRelationTypeKey, contextInfo);
    }

    @Override
    public List<LoLoRelationInfo> getLoLoRelationsByLoId(String loId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().getLoLoRelationsByLoId(loId, contextInfo);
    }

    @Override
    public List<String> searchForLoLoRelationIds(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().searchForLoLoRelationIds(criteria, contextInfo);
    }

    @Override
    public List<LoLoRelationInfo> searchForLoLoRelations(QueryByCriteria criteria, ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().searchForLoLoRelations(criteria, contextInfo);
    }

    @Override
    public List<ValidationResultInfo> validateLoLoRelation(String validationTypeKey, LoLoRelationInfo loLoRelationInfo, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().validateLoLoRelation(validationTypeKey, loLoRelationInfo, contextInfo);
    }

    @Override
    public LoLoRelationInfo createLoLoRelation(String loLoRelationTypeKey, LoLoRelationInfo loLoRelationInfo, ContextInfo contextInfo) throws DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException {
        return getNextDecorator ().createLoLoRelation(loLoRelationTypeKey, loLoRelationInfo, contextInfo);
    }

    @Override
    public LoLoRelationInfo updateLoLoRelation(String loLoRelationId, LoLoRelationInfo loLoRelationInfo, ContextInfo contextInfo) throws DataValidationErrorException, DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException, ReadOnlyException, VersionMismatchException {
        return getNextDecorator ().updateLoLoRelation(loLoRelationId, loLoRelationInfo, contextInfo);
    }

    @Override
    public StatusInfo deleteLoLoRelation(String loLoRelationId, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException, PermissionDeniedException {
        return getNextDecorator ().deleteLoLoRelation(loLoRelationId, contextInfo);
    }

    @Override
    public TypeInfo getLoCategoryType(String loCategoryTypeKey, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException {
        return getNextDecorator ().getLoCategoryType(loCategoryTypeKey, contextInfo);
    }

    @Override
    public List<TypeInfo> getLoCategoryTypes() throws OperationFailedException {
        return getNextDecorator ().getLoCategoryTypes();
    }

    @Override
    public List<TypeInfo> getSearchTypes(ContextInfo contextInfo) throws InvalidParameterException, MissingParameterException, OperationFailedException {
        return getNextDecorator ().getSearchTypes(contextInfo);
    }

    @Override
    public TypeInfo getSearchType(String searchTypeKey, ContextInfo contextInfo) throws DoesNotExistException, InvalidParameterException, MissingParameterException, OperationFailedException {
        return getNextDecorator ().getSearchType(searchTypeKey, contextInfo);
    }


    @Override
    public SearchResultInfo search(SearchRequestInfo searchRequestInfo, ContextInfo contextInfo) throws MissingParameterException, OperationFailedException, PermissionDeniedException, InvalidParameterException {
        return getNextDecorator ().search(searchRequestInfo, contextInfo);
    }
}
