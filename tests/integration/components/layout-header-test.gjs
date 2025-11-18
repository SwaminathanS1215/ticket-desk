import { module, test } from 'qunit';
import { setupRenderingTest } from 'ticket-desk/tests/helpers';
import { render } from '@ember/test-helpers';
import LayoutHeader from 'ticket-desk/components/layout-header';

module('Integration | Component | layout-header', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><LayoutHeader /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <LayoutHeader>
        template block text
      </LayoutHeader>
    </template>);

    assert.dom().hasText('template block text');
  });
});
