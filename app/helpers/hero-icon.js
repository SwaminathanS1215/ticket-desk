import { helper } from '@ember/component/helper';
import { htmlSafe } from '@ember/template';
import * as Icons from '@heroicons/react/24/outline';

export default helper(function heroIcon([name]) {
  const Icon = Icons[name];
  if (!Icon) return '';

  return htmlSafe(Icon({ className: "w-5 h-5" }).props.children);
});
