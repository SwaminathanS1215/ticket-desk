import { module, test } from 'qunit';
import { setupRenderingTest } from 'ticket-desk/tests/helpers';
import { render } from '@ember/test-helpers';
import BarChartCard from 'ticket-desk/components/bar-chart-card';

module('Integration | Component | bar-chart-card', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><BarChartCard /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <BarChartCard>
        template block text
      </BarChartCard>
    </template>);

    assert.dom().hasText('template block text');
  });
});
