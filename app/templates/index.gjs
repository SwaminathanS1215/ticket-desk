import Component from '@glimmer/component';
import PublicLayout from '../components/public-layout.gjs';
import LoginPage from '../components/login-page.gjs';

export default class IndexTemplate extends Component {
  <template>
    <PublicLayout>
      <LoginPage />
    </PublicLayout>
  </template>
}
