import Component from '@glimmer/component';
import PublicLayout from '../components/public-layout.gjs';
import SignupPage from '../components/signup-page.gjs';

export default class SignupTemplate extends Component {
  <template>
    <PublicLayout>
      <SignupPage @onSubmit={{@controller.signup}} @error={{@controller.error}} />
    </PublicLayout>
  </template>
}
