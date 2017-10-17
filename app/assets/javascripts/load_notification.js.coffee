$ ->
  content = $('.notification-list')
  viewMore = $('#view-more')

  isLoadingNextPage = false
  lastLoadAt = null
  minTimeBetweenPages = 1000
  loadNextPageAt = 1000

  waitedLongEnoughBetweenPages = ->
    return lastLoadAt == null || new Date() - lastLoadAt > minTimeBetweenPages

  approachingBottomOfPage = ->
    return document.documentElement.clientHeight +
      $(document).scrollTop() < document.body.offsetHeight - loadNextPageAt

  nextPage = ->
    url = viewMore.find('a').attr('href')

    return if isLoadingNextPage || !url

    viewMore.addClass('loading')
    isLoadingNextPage = true
    lastLoadAt = new Date()

    $.ajax
      url: url,
      method: 'GET',
      dataType: 'script',
      success: ->
        viewMore.removeClass('loading');
        isLoadingNextPage = false;
        lastLoadAt = new Date();

  $(window).scroll ->
    if approachingBottomOfPage() && waitedLongEnoughBetweenPages()
      nextPage()

  viewMore.find('a').click (e) ->
    nextPage()
    e.preventDefaults()
