package com.sigmasys.kuali.ksa.model.fm;

import com.sigmasys.kuali.ksa.model.Identifiable;

/**
 * FeeManagementManifest status values.
 *
 * @author Michael Ivanov
 */
public enum FeeManagementManifestStatus implements Identifiable {

    PENDING(FeeManagementManifestStatus.PENDING_CODE),
    CHARGED(FeeManagementManifestStatus.CHARGED_CODE),
    SKIPPED(FeeManagementManifestStatus.SKIPPED_CODE);

    public static final String PENDING_CODE = "P";
    public static final String CHARGED_CODE = "C";
    public static final String SKIPPED_CODE = "S";


    private String id;

    private FeeManagementManifestStatus(String id) {
        this.id = id;
    }

    @Override
    public String getId() {
        return id;
    }

    @Override
    public String toString() {
        switch (this) {
            case PENDING:
                return "Pending";
            case CHARGED:
                return "Charged";
            case SKIPPED:
                return "Skipped";
        }
        throw new IllegalStateException("No Fee Management Manifest status found for " + name() + " value");
    }
}
