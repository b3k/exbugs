$(document).ready ->
  $('#member_username').autocomplete serviceUrl: '/api/users/autocomplete'
