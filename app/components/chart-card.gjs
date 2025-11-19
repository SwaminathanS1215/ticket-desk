import Component from '@glimmer/component';
import chart from '../modifiers/chart';

export default class ChartCardComponent extends Component {
  <template>
    <div class="w-44 h-44 p-2">
      <canvas class="w-full h-full" {{chart @data}}></canvas>
    </div>
  </template>
}
