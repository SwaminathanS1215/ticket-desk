import Component from '@glimmer/component';

export default class PublicLayout extends Component {
  <template>
    <div class="min-h-screen bg-gray-100 flex items-center justify-center">
      {{yield}}
    </div>
  </template>
}
