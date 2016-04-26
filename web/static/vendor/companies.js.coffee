$(document).ready ->
  currentPage = 1

  $(window).scroll ->
    if $("#companies").length && !$('#placeholder').length && $(document).height() - $(window).height() <= $(window).scrollTop()
      currentPage++
      $.ajax
        url: "?page=" + currentPage
        success: (html) ->
          if html
            $("#companies").append jQuery(html).find("#companies").html()
