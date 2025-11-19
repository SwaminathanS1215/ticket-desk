import { module, test } from 'qunit';
import { setupRenderingTest } from 'ticket-desk/tests/helpers';
import { render } from '@ember/test-helpers';
import Dashboard from 'ticket-desk/components/dashboard';

module('Integration | Component | dashboard', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><Dashboard /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <Dashboard>
        template block text
      </Dashboard>
    </template>);

    assert.dom().hasText('template block text');
  });
});
