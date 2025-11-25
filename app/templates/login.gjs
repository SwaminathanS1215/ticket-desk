import Component from '@glimmer/component';
import PublicLayout from '../components/public-layout.gjs';
import LoginPage from '../components/login-page.gjs';

export default class LoginTemplate extends Component {
  <template>
    <PublicLayout>
      <LoginPage @onSubmit={{@controller.login}} @error={{@controller.error}} />
    </PublicLayout>
  </template>
}
