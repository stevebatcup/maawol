Maawol.FilterModule.filter 'rawHtml', ['$sce', ($sce) ->
  return (val) ->
    return $sce.trustAsHtml(val)
]