package com.sigmasys.kuali.ksa.service.impl;

import com.sigmasys.kuali.ksa.model.AccountBlock;
import com.sigmasys.kuali.ksa.model.security.Permission;
import com.sigmasys.kuali.ksa.service.*;
import com.sigmasys.kuali.ksa.service.security.PermissionUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;


/**
 * AccountBlockService implementation.
 * <p/>
 *
 * @author Michael Ivanov
 */
@Service("accountBlockService")
@Transactional(readOnly = true)
@SuppressWarnings("unchecked")
public class AccountBlockServiceImpl extends GenericPersistenceService implements AccountBlockService {


    private static final Log logger = LogFactory.getLog(AccountBlockServiceImpl.class);


    @Autowired
    private AuditableEntityService entityService;


    /**
     * Creates and persists a new instance of AccountBlock based on the given parameters.
     *
     * @param code        AccountBlock code
     * @param name        AccountBlock name
     * @param description AccountBlock description
     * @return AccountBlock instance
     */
    @Override
    @Transactional(readOnly = false)
    public AccountBlock createAccountBlock(String code, String name, String description) {

        PermissionUtils.checkPermission(Permission.CREATE_ACCOUNT_BLOCK);

        if (StringUtils.isBlank(code)) {
            String errMsg = "AccountBlock code cannot be empty";
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        if (StringUtils.isBlank(name)) {
            String errMsg = "AccountBlock name cannot be empty";
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        return entityService.createAuditableEntity(code, name, description, AccountBlock.class);
    }

    /**
     * Persists AccountBlock instance in the persistent store
     *
     * @param accountBlock AccountBlock instance
     * @return AccountBlock ID
     */
    @Override
    @Transactional(readOnly = false)
    public Long persistAccountBlock(AccountBlock accountBlock) {

        PermissionUtils.checkPermission(Permission.UPDATE_ACCOUNT_BLOCK);

        if (StringUtils.isBlank(accountBlock.getCode())) {
            String errMsg = "AccountBlock code cannot be empty";
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        if (StringUtils.isBlank(accountBlock.getName())) {
            String errMsg = "AccountBlock name cannot be empty";
            logger.error(errMsg);
            throw new IllegalArgumentException(errMsg);
        }

        return entityService.persistAuditableEntity(accountBlock);
    }

    /**
     * Removes AccountBlock entity from the persistent store by ID.
     *
     * @param accountBlockId AccountBlock ID
     * @return true if AccountBlock entity has been deleted
     */
    @Override
    @Transactional(readOnly = false)
    public boolean deleteAccountBlock(Long accountBlockId) {
        PermissionUtils.checkPermission(Permission.DELETE_ACCOUNT_BLOCK);
        return entityService.deleteAuditableEntity(accountBlockId, AccountBlock.class);
    }

    /**
     * Retrieves AccountBlock entity by ID from the persistent store.
     *
     * @param accountBlockId AccountBlock ID
     * @return AccountBlock instance
     */
    @Override
    public AccountBlock getAccountBlock(Long accountBlockId) {
        PermissionUtils.checkPermission(Permission.READ_ACCOUNT_BLOCK);
        return entityService.getAuditableEntity(accountBlockId, AccountBlock.class);
    }

    /**
     * Returns all account blocks from the persistent store sorted by code in the ascending order.
     *
     * @return list of AccountBlock instances
     */
    @Override
    public List<AccountBlock> getAccountBlocks() {
        PermissionUtils.checkPermission(Permission.READ_ACCOUNT_BLOCK);
        List<AccountBlock> accountBlocks = entityService.getAuditableEntities(AccountBlock.class);
        if (CollectionUtils.isNotEmpty(accountBlocks)) {
            Collections.sort(accountBlocks, new Comparator<AccountBlock>() {
                @Override
                public int compare(AccountBlock block1, AccountBlock block2) {
                    return block1.getCode().compareToIgnoreCase(block2.getCode());
                }
            });
        }
        return accountBlocks;
    }


}
