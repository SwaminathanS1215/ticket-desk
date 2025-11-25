import { module, test } from 'qunit';
import { setupTest } from 'ticket-desk/tests/helpers';

module('Unit | Controller | app/create-ticket', function (hooks) {
  setupTest(hooks);

  // TODO: Replace this with your real tests.
  test('it exists', function (assert) {
    let controller = this.owner.lookup('controller:app/create-ticket');
    assert.ok(controller);
  });
});
