package org.kuali.student.lum.program.client.major.edit;

import com.google.gwt.core.client.GWT;
import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.event.shared.HandlerManager;
import com.google.gwt.user.client.Window;
import org.kuali.student.common.ui.client.application.ViewContext;
import org.kuali.student.common.ui.client.mvc.Callback;
import org.kuali.student.common.ui.client.mvc.DataModel;
import org.kuali.student.common.ui.client.mvc.ModelRequestCallback;
import org.kuali.student.common.ui.client.mvc.history.HistoryManager;
import org.kuali.student.common.ui.client.service.DataSaveResult;
import org.kuali.student.common.ui.client.widgets.KSButton;
import org.kuali.student.common.ui.client.widgets.KSButtonAbstract;
import org.kuali.student.common.ui.client.widgets.notification.KSNotifier;
import org.kuali.student.common.ui.shared.IdAttributes;
import org.kuali.student.core.assembly.data.Data;
import org.kuali.student.core.assembly.data.QueryPath;
import org.kuali.student.core.validation.dto.ValidationResultInfo;
import org.kuali.student.lum.common.client.widgets.AppLocations;
import org.kuali.student.lum.program.client.ProgramConstants;
import org.kuali.student.lum.program.client.ProgramRegistry;
import org.kuali.student.lum.program.client.ProgramSections;
import org.kuali.student.lum.program.client.ProgramUtils;
import org.kuali.student.lum.program.client.events.*;
import org.kuali.student.lum.program.client.major.MajorController;
import org.kuali.student.lum.program.client.properties.ProgramProperties;
import org.kuali.student.lum.program.client.rpc.AbstractCallback;
import org.kuali.student.lum.program.client.widgets.ProgramSideBar;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

/**
 * @author Igor
 */
public class MajorEditController extends MajorController {

    private final KSButton saveButton = new KSButton(ProgramProperties.get().common_save());
    private final KSButton cancelButton = new KSButton(ProgramProperties.get().common_cancel(), KSButtonAbstract.ButtonStyle.ANCHOR_LARGE_CENTERED);
    private final Set<String> existingVariationIds = new TreeSet<String>();

    /**
     * Constructor.
     *
     * @param programModel
     */
    public MajorEditController(DataModel programModel, ViewContext viewContext, HandlerManager eventBus) {
        super(programModel, viewContext, eventBus);
        configurer = GWT.create(MajorEditConfigurer.class);
        sideBar.setState(ProgramSideBar.State.EDIT);
        initHandlers();
    }

    @Override
    protected void configureView() {
        super.configureView();
        if (!initialized) {
            eventBus.fireEvent(new MetadataLoadedEvent(programModel.getDefinition(), this));
            List<Enum<?>> excludedViews = new ArrayList<Enum<?>>();
            excludedViews.add(ProgramSections.PROGRAM_REQUIREMENTS_EDIT);
            excludedViews.add(ProgramSections.SUPPORTING_DOCUMENTS_EDIT);
            addCommonButton(ProgramProperties.get().program_menu_sections(), saveButton, excludedViews);
            addCommonButton(ProgramProperties.get().program_menu_sections(), cancelButton, excludedViews);
            initialized = true;
        }
    }

    private void initHandlers() {
        saveButton.addClickHandler(new ClickHandler() {

            @Override
            public void onClick(ClickEvent event) {
                doSave();
            }
        });
        cancelButton.addClickHandler(new ClickHandler() {

            @Override
            public void onClick(ClickEvent event) {
                doCancel();
            }
        });
        eventBus.addHandler(UpdateEvent.TYPE, new UpdateEvent.Handler() {
            @Override
            public void onEvent(UpdateEvent event) {
                doSave(event.getOkCallback());
            }
        });

        eventBus.addHandler(SpecializationSaveEvent.TYPE, new SpecializationSaveEvent.Handler() {
            @Override
            public void onEvent(SpecializationSaveEvent event) {
                Data variations = (Data) programModel.get(ProgramConstants.VARIATIONS);
                updateExistingVariationIds(variations);
                variations.add(event.getData());
                doSave();
            }
        });
        eventBus.addHandler(AddSpecializationEvent.TYPE, new AddSpecializationEvent.Handler() {
            @Override
            public void onEvent(AddSpecializationEvent event) {
                String id = (String) programModel.get(ProgramConstants.ID);
                ProgramRegistry.setRow(programModel.<Data>get(ProgramConstants.VARIATIONS).size());
                ProgramRegistry.setData(ProgramUtils.createNewSpecializationBasedOnMajor(programModel));
                ViewContext viewContext = new ViewContext();
                viewContext.setId(id);
                viewContext.setIdType(IdAttributes.IdType.OBJECT_ID);
                HistoryManager.navigate(AppLocations.Locations.EDIT_VARIATION.getLocation(), viewContext);

            }
        });
        eventBus.addHandler(SpecializationUpdateEvent.TYPE, new SpecializationUpdateEvent.Handler() {
            @Override
            public void onEvent(SpecializationUpdateEvent event) {
                updateExistingVariationIds((Data) programModel.get(ProgramConstants.VARIATIONS));
                doSave();
            }
        });
        eventBus.addHandler(ModelLoadedEvent.TYPE, new ModelLoadedEvent.Handler() {
            @Override
            public void onEvent(ModelLoadedEvent event) {
                Enum<?> changeSection = ProgramRegistry.getSection();
                if (changeSection != null) {
                    showView(changeSection);
                    ProgramRegistry.setSection(null);
                } else {
                    String id = (String) programModel.get(ProgramConstants.ID);
                    if (id == null) {
                        showView(ProgramSections.PROGRAM_DETAILS_EDIT);
                    } else {
                        showView(ProgramSections.SUMMARY);
                    }
                }
            }
        });
        eventBus.addHandler(StoreRequirementIDsEvent.TYPE, new StoreRequirementIDsEvent.Handler() {
            @Override
            public void onEvent(StoreRequirementIDsEvent event) {
                String programId = event.getProgramId();       //this can be either Major or Specialization ID
                String programType = event.getProgramType();
                List<String> ids = event.getProgramRequirementIds();
                Data programRequirements = null;

                //specializations will be handled differently from Major
                if (programType.equals("kuali.lu.type.Variation")) {
                    Data variationMap = programModel.get(ProgramConstants.VARIATIONS);
                    // find the specialization that we need to update
                    for (Data.Property property : variationMap) {
                        final Data variationData = property.getValue();
                        if (variationData.get(ProgramConstants.ID).equals(programId)) {
                            variationData.set(ProgramConstants.PROGRAM_REQUIREMENTS, new Data());
                            programRequirements = variationData.get(ProgramConstants.PROGRAM_REQUIREMENTS);
                            break;
                        }
                    }
                } else {
                    programModel.set(QueryPath.parse(ProgramConstants.PROGRAM_REQUIREMENTS), new Data());
                    programRequirements = programModel.get(ProgramConstants.PROGRAM_REQUIREMENTS);
                }

                if (programRequirements == null) {
                    Window.alert("Cannot find program requirements in data model.");
                    GWT.log("Cannot find program requirements in data model", null);
                    return;
                }

                for (String id : ids) {
                    programRequirements.add(id);
                }
                doSave();
            }
        });
        eventBus.addHandler(ChangeViewEvent.TYPE, new ChangeViewEvent.Handler() {
            @Override
            public void onEvent(ChangeViewEvent event) {
                showView(event.getViewToken());
            }
        });
    }

    private void updateExistingVariationIds(Data variations) {
        existingVariationIds.clear();
        for (Data.Property prop : variations) {
            existingVariationIds.add((String) ((Data) prop.getValue()).get(ProgramConstants.ID));
        }
    }

    private void doSave(final Callback<Boolean> okCallback) {
        requestModel(new ModelRequestCallback<DataModel>() {
            @Override
            public void onModelReady(DataModel model) {
                MajorEditController.this.updateModelFromCurrentView();
                model.validate(new Callback<List<ValidationResultInfo>>() {
                    @Override
                    public void exec(List<ValidationResultInfo> result) {
                        boolean isSectionValid = isValid(result, true);
                        if (isSectionValid) {
                            saveData(okCallback);
                        } else {
                            okCallback.exec(false);
                            eventBus.fireEvent(new ValidationFailedEvent());
                            Window.alert("Save failed.  Please check fields for errors.");
                        }
                    }
                });

            }

            @Override
            public void onRequestFail(Throwable cause) {
                GWT.log("Unable to retrieve model for validation and save", cause);
            }
        });
    }

    private void doCancel() {
        showView(ProgramSections.SUMMARY);
    }

    @Override
    protected void doSave() {
        doSave(NO_OP_CALLBACK);
    }

    private void saveData(final Callback<Boolean> okCallback) {
        programRemoteService.saveData(programModel.getRoot(), new AbstractCallback<DataSaveResult>(ProgramProperties.get().common_savingData()) {
            @Override
            public void onSuccess(DataSaveResult result) {
                super.onSuccess(result);
                if (result.getValidationResults() != null && !result.getValidationResults().isEmpty()) {
                    isValid(result.getValidationResults(), false, true);
                    StringBuilder msg = new StringBuilder();
                    for (ValidationResultInfo vri : result.getValidationResults()) {
                        msg.append(vri.getMessage());
                    }
                    eventBus.fireEvent(new ValidationFailedEvent());
                    okCallback.exec(false);
                } else {
                    programModel.setRoot(result.getValue());
                    setHeaderTitle();
                    setStatus();
                    resetFieldInteractionFlag();

                    handleSpecializations();
                    throwAfterSaveEvent();
                    HistoryManager.logHistoryChange();
                    if (getCurrentViewEnum().name().equals(ProgramSections.SPECIALIZATIONS_EDIT.name())) {
                        showView(getCurrentViewEnum());
                    }
                    KSNotifier.show(ProgramProperties.get().common_successfulSave());
                    okCallback.exec(true);
                }
            }
        });
    }

    /**
     * Handles after save work for specializations.
     */
    private void handleSpecializations() {
        String newVariationId = null;
        Data variations = programModel.get(ProgramConstants.VARIATIONS);
        for (Data.Property prop : variations) {
            String varId = (String) ((Data) prop.getValue()).get(ProgramConstants.ID);
            if (!existingVariationIds.contains(varId)) {
                newVariationId = varId;
                existingVariationIds.add(newVariationId);
                break;
            }
        }
        if (newVariationId != null) {
            eventBus.fireEvent(new SpecializationCreatedEvent(newVariationId));
        }
    }

    private void throwAfterSaveEvent() {
        eventBus.fireEvent(new AfterSaveEvent(programModel, this));
    }
}