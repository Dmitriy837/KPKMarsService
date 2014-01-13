jQuery ->
  $(document).on('click', '#flash_notice', ->
    $('#flash_notice').remove()
  )
  $(document).on('click', '#flash_alert', ->
    $('#flash_alert').remove()
  )
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
