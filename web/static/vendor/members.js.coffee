$(document).ready ->
  currentPage = 1

  $(window).scroll ->
    if $("#members").length && !$('#placeholder').length && $(document).height() - $(window).height() <= $(window).scrollTop()
      currentPage++
      $.ajax
        url: "?page=" + currentPage
        success: (html) ->
          if html
            $("#members").append jQuery(html).find("#members").html()
