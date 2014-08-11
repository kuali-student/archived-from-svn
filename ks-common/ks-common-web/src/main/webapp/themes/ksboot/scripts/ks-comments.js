var deletedObjects = [];

function initComments() {
    deletedObjects = [];
}

jQuery(function () {
    initComments();
});

function getRowContainer(elem) {
    var id = jQuery(elem).attr('id');
    var index = id.substring(id.lastIndexOf('_line') + '_line'.length, id.length);
    return jQuery("#KS-collection-rowId_line" + index);
}

function toggleCommentButtons(elem) {
    var rowContainer = getRowContainer(elem);
    jQuery(rowContainer).find('.ks-toggleable').each(function () {
        jQuery(this).toggle();
    });
}

function toggleDeleteElements(elem) {
    var rowContainer = getRowContainer(elem);
    jQuery(rowContainer).find('.ks-toggle-delete').each(function () {
        jQuery(this).toggle();
    });
    jQuery(rowContainer).find('.ks-deleted-comment').each(function () {
        jQuery(this).toggleClass("ks-deleting-comment");
    });
}

function addDeletedObject(elem){
    var rowContainer = getRowContainer(elem);
    var rowId = jQuery(rowContainer).attr('id');
    var deletedObject = {};

    jQuery(rowContainer).find('.ks-comment-textArea-field').each(function () {
        jQuery(this).find(":input").each(function () {
            var textId = jQuery(this).attr('id');
            var textValue = jQuery(this).val();
//            deletedObject["key"] = textId;
            deletedObject["textField"] = {"id": textId, "value": textValue};
        });
    });
    jQuery(rowContainer).find('.ks-comment-metaData-container').each(function () {
        var metadata = [];
        jQuery(this).find('.ks-comment-metaData-item').each(function () {
            var keyValuePair = {};
            keyValuePair["key"] = jQuery(this).attr('id');
            var value = jQuery(this).val();
            if (value === '') {
                value = jQuery(this).text();
            }
            keyValuePair["value"] = value;
            metadata.push(keyValuePair);
        });
        deletedObject['metadata'] = metadata;
    });
    deletedObjects.push({"key": rowId, "deletedObject": deletedObject});
}

function restoreDeletedObject(){
    var rowContainer = getRowContainer(elem);
    var itemToRemove = getDeletedComment(rowContainer.attr('id'));

    jQuery(rowContainer).find('.ks-comment-textArea-field').each(function () {
        jQuery(this).find(":input").each(function () {
            var textId = jQuery(this).attr('id');
            var textValue = itemToRemove.deletedObject.textField.filter(function (){
                return this.id = textId;
            });
            jQuery(this).val(textValue);
        });
    });
    jQuery(rowContainer).find('.ks-comment-metaData-container').each(function () {
        jQuery(this).find('.ks-comment-metaData-item').each(function () {
            var key = jQuery(this).attr('id');
            var value = itemToRemove.deletedObject.metadata.filter(function (){
                return this.key = key;
            })
            jQuery(this).text(value);
        });
    });
    deletedObjects.splice(jQuery.inArray(itemtoRemove, deletedObjects), 1);
}

function getDeletedComment(key) {
    deletedObjects.filter(function () {
        return this.key === key;
    });
}

function deleteComment(baseUrl, controllerUrl, elem) {
    if (console) {
        console.log("deleteComment()... dirtyFieldCount = " + dirtyFormState.dirtyFieldCount);
    }
    var rowContainer = getRowContainer(elem);
    var data = jQuery(elem).data('submit_data');
    var index = parseInt(data['actionParameters[selectedLineIndex]']);
    var formData = jQuery('#kualiForm').serialize() + '&' + jQuery.param(data);
    var targetUrl = baseUrl + "/kr-krad" + controllerUrl + "?methodToCall=ajaxDeleteComment";

    jsonPost(targetUrl, formData, function(data){
        jQuery(rowContainer).remove();
        dirtyFormState.dirtyFieldCount--;
        jQuery("#Comment_list_Header").find("span").text("Comments(" + data.count + ")");
        jQuery('[id^="KS-collection-rowId_line"]').each(function(){
            jQuery(this).find("button").each(function(){
                var submitData = jQuery(this).data('submit_data');
                var i = parseInt(submitData['actionParameters[selectedLineIndex]']);
                if(i > index){
                    submitData['actionParameters[selectedLineIndex]'] = i - 1;
                    jQuery(this).attr('data-submit_data',JSON.stringify(submitData));
                }
            });
        });
    });
}

function updateComment(baseUrl, controllerUrl, elem) {
    if(console){
        console.log("updateComment()... dirtyFieldCount = " + dirtyFormState.dirtyFieldCount);
    }
    var rowContainer = getRowContainer(elem);
    var submitData = jQuery(elem).data('submit_data');
    var index = parseInt(submitData['actionParameters[selectedLineIndex]']);
    var formData = jQuery('#kualiForm').serialize() + '&' + jQuery.param(submitData);
    var targetUrl = baseUrl + "/kr-krad" + controllerUrl + "?methodToCall=ajaxUpdateComment";

    jsonPost(targetUrl, formData, function(data){
        toggleCommentButtons(elem);
        jQuery("#KS-CommentField_UI_ID_line" + index ).text(data.commentWrapper.commentTextUI);
        jQuery("#lastEditor-container-id_line" + index).show();
        jQuery("#lastEditor-name-id_line" + index).text(data.commentWrapper.lastEditorName);
        jQuery("#lastEditor-date-id_line" + index).text(data.commentWrapper.lastEditedDate);
        jQuery(rowContainer).find(".dirty").each(function(){
            dirtyFormState.dirtyFieldCount--;
            this.defalutValue = data.commentWrapper.commentTextUI;
            jQuery(this).removeClass("dirty");
        });
    });
}

function jsonPost(targetUrl, formData, callbackFunction){
    jQuery.ajax({
        dataType: "json",
        url: targetUrl,
        type: "POST",
        data: formData,
        success: function (data, textStatus, jqXHR) {
            if(data.hasErrors){
                processErrors(data, 'KS-collection-rowId_line'+index, baseUrl);
            }else{
                callbackFunction(data);
            }
        },
        error: function (jqXHR, status, error) {
            processException(jqXHR, 'KS-collection-rowId_line'+index, baseUrl);
        }
    });
}

function processException(request, parentId, baseUrl){
    // global errors on form
    var globalErrorsUl = jQuery('<ul id="pageValidationList" class="uif-validationMessagesList" aria-labelledby="pageValidationHeader" />');

        var globalErrorLi = createGlobalErrorLi(request.responseText, baseUrl, parentId, 1);
        jQuery(globalErrorsUl).append(globalErrorLi);

    // global errors on form
    var globalErrorsDiv = createGlobalErrorsDiv(baseUrl, "KS-Comment-pageId", 1, globalErrorsUl);
    jQuery("#KS-Comment-pageId" + " header:eq(0)").after(globalErrorsDiv);
}

function processErrors(data, parentId, baseUrl){
    // global errors on form
    var globalErrorsUl;
    if(data.messageMap.errorCount > 1) {
        globalErrorsUl = jQuery('<ul id="pageValidationList" class="uif-validationMessagesList" aria-labelledby="pageValidationHeader" />');
    } else {
        globalErrorsUl = jQuery('<ul id="pageValidationList" class="uif-validationMessagesList uif-pageValidationMessage-single" aria-labelledby="pageValidationHeader" />');
    }

    jQuery.each(data.translatedErrorMessages, function(key, value){
        var globalErrorLi = createGlobalErrorLi(value[0], baseUrl, parentId, data.messageMap.errorCount);
        jQuery(globalErrorsUl).append(globalErrorLi);
    });

    // global errors on form
    var globalErrorsDiv = createGlobalErrorsDiv(baseUrl, "KS-Comment-pageId", data.messageMap.errorCount, globalErrorsUl);
    jQuery("#KS-Comment-pageId" + " header:eq(0)").after(globalErrorsDiv);
}

function cancelEditComment(elem){
    if(console){
        console.log("cancelEditComment() ... dirtyFieldCount = " + dirtyFormState.dirtyFieldCount);
    }
    var rowContainer = getRowContainer(elem);
    jQuery(rowContainer).find(".dirty").each(function(){
        dirtyFormState.dirtyFieldCount--;
        this.value = this.defaultValue;
        jQuery(this).removeClass("dirty");
    });
    toggleCommentButtons(elem);
}

function cancelDeleteComment(elem){
    if(console){
        console.log("cancelDeleteComment()... dirtyFieldCount = " + dirtyFormState.dirtyFieldCount);
    }
    var rowContainer = getRowContainer(elem);
    dirtyFormState.dirtyFieldCount--;
    jQuery(this).removeClass("dirty");
    toggleDeleteElements(elem);
}

function confirmEditComment(elem){
    if(console){
        console.log("confirmEditComment()... dirtyFieldCount = " + dirtyFormState.dirtyFieldCount);
    }
    toggleCommentButtons(elem);
}

function confirmDeleteComment(elem){
    if(console){
        console.log("confirmDeleteComment()... dirtyFieldCount = " + dirtyFormState.dirtyFieldCount);
    }
    var rowContainer = getRowContainer(elem);
    dirtyFormState.dirtyFieldCount++;
    jQuery(this).addClass("dirty");
    toggleDeleteElements(elem);
}