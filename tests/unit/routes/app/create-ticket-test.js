import { module, test } from 'qunit';
import { setupTest } from 'ticket-desk/tests/helpers';

module('Unit | Route | app/create-ticket', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    let route = this.owner.lookup('route:app/create-ticket');
    assert.ok(route);
  });
});
