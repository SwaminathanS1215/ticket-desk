import { helper } from '@ember/component/helper';
import { getOwner } from '@ember/application';

export default helper(function isActiveRoute(positional, named, env) {
  let router = getOwner(env).lookup('service:router');

  const [routeName] = positional;
  return router.currentRouteName.startsWith(routeName);
});
