import { module, test } from 'qunit';
import { setupRenderingTest } from 'ticket-desk/tests/helpers';
import { render } from '@ember/test-helpers';
import ChartCard from 'ticket-desk/components/chart-card';

module('Integration | Component | chart-card', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><ChartCard /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <ChartCard>
        template block text
      </ChartCard>
    </template>);

    assert.dom().hasText('template block text');
  });
});
