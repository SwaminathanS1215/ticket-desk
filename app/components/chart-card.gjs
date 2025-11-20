import Component from '@glimmer/component';
import chart from '../modifiers/chart';

export default class ChartCardComponent extends Component {
  get totalTickets() {
    return this.args.data.data.reduce((sum, item) => sum + item.value, 0);
  }

  <template>
    <div class="bg-white rounded-lg shadow p-6 flex-1">
      <h3 class="text-lg font-semibold mb-4">{{@data.title}}</h3>
      <div class="h-64 flex items-center justify-center">
        <div class="relative w-48 h-48">
          <canvas class="w-full h-full" {{chart @data}}></canvas>
          <div class="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
            <span class="text-3xl font-bold">{{this.totalTickets}}</span>
            <span class="text-sm text-gray-500">tickets</span>
          </div>
        </div>
      </div>
    </div>
  </template>
}
