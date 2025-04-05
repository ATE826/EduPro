import logo from './logo.svg';
import './App.css';
import eduProImage from './Img/EduPro.png';
import 'bootstrap/dist/css/bootstrap.min.css';

import { Container, Navbar, Nav, Button } from 'react-bootstrap';

function App() {
  return (
    <div className="App">
      <header className="Header">
        <Navbar style={{ backgroundColor: 'var(--red)'}} expand="lg">
          <Container fluid>
            <div style={{ display: 'flex', alignItems: 'center' }}>
              <img className='Logo' src={eduProImage} alt="EduPro Logo" />
              <p style={{color:'var(--orange'}}><span className='Logo-text'>EduPro</span>&copy;</p>
            </div>
            <div style={{ display: 'flex', alignItems: 'center' }}>
              <button className='Btn-auth'>Войти</button>
            </div>

          </Container>
        </Navbar>
      </header>

      <main>
        
      </main>

      <footer>
        
      </footer>
    </div>
  );
}

export default App;
