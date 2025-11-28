import Component from '@glimmer/component';
import AppToast from '../components/app-toast.gjs';

export default class ApplicationTemplate extends Component {
  <template>
    {{outlet}}
    <AppToast />
  </template>
}
