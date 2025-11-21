import { module, test } from 'qunit';
import { setupRenderingTest } from 'ticket-desk/tests/helpers';
import { render } from '@ember/test-helpers';
import CreateMenu from 'ticket-desk/components/create-menu';

module('Integration | Component | create-menu', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><CreateMenu /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <CreateMenu>
        template block text
      </CreateMenu>
    </template>);

    assert.dom().hasText('template block text');
  });
});
