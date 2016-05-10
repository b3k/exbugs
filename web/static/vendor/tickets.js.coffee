$(document).ready ->
   $('#ticket_body').summernote()

   $('#ticket_tags_tag').tagit
    removeConfirmation: false
    singleField: true
    singleFieldNode: $("#ticket_tags")
    allowSpaces: true
    tagLimit: 5
