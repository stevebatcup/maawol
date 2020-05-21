var Maawol = (typeof exports !== "undefined" && exports !== null) && exports || (this.Maawol = {});
Maawol.ControllerModule = angular.module('Maawol.controllers', []);
Maawol.FilterModule = angular.module('Maawol.filters', []);
Maawol.FactoryModule = angular.module('Maawol.factories', []);
Maawol.DirectiveModule = angular.module('Maawol.directives', []);

var moduleName = "Maawol_NG"
window.App = angular.module(moduleName, ['rails',
  'ngAnimate',
  'ngCookie',
  'Maawol.directives',
  'Maawol.factories',
  'Maawol.filters',
  'Maawol.controllers'
]).config(function(cookiesProvider, $sceProvider) {
  cookiesProvider.useDefaults({
    path: '/admin',
    maxAge: 24*60*60
  });
  $sceProvider.enabled(true);
});
window.App.run(function ($rootScope) {
  $rootScope._ = _;
});
$(document).on('ready page:load', function() {
  $('[ng-controller]').each(function(index, root) {
    if (!$(root).hasClass('ng-scope')) {
      angular.bootstrap($(root), [moduleName]);
    }
  })
});