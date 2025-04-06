// src/pages/HomePage.js

import logo from '../logo.svg';
import '../App.css';
import eduProImage from '../Img/EduPro.png';
import tgImage from '../Img/tg.svg';
import mailImage from '../Img/mail.svg';
import 'bootstrap/dist/css/bootstrap.min.css';
import { Container, Navbar } from 'react-bootstrap';

function HomePage() {
  return (
    <div className="App">
      <header className="Header">
        <Navbar style={{ backgroundColor: 'var(--red)' }} expand="lg">
          <Container fluid>
            <div style={{ display: 'flex', alignItems: 'center' }}>
              <img className='Logo' src={eduProImage} alt="EduPro Logo" />
              <p style={{ color: 'var(--orange)', marginTop: '20px' }}>
                <span className='Logo-text'>EduPro</span>&copy;
              </p>
            </div>
            <div style={{ display: 'flex', alignItems: 'center' }}>
              <button className='Btn-auth'>Войти</button>
            </div>
          </Container>
        </Navbar>
      </header>

      <main>
        <div style={{ height: '500px' }}>adasasdsadsadasdasdadas</div>
      </main>

      <footer>
        <Navbar style={{ backgroundColor: 'var(--red)' }} expand="lg">
          <Container fluid>
            <div style={{ display: 'flex', alignItems: 'center' }}>
              <img style={{ marginRight: '50px' }} className='hrefs' src={mailImage} alt="EduPro Logo" />
              <p className='text-orange' style={{ marginTop: '20px' }}>EduPro@gmail.com</p>
            </div>
            <div style={{ display: 'flex', alignItems: 'center' }}>
              <p className='text-orange' style={{ marginTop: '20px' }}>@EduPro</p>
              <img style={{ marginLeft: '50px' }} className='hrefs' src={tgImage} alt="EduPro Logo" />
            </div>
          </Container>
        </Navbar>
      </footer>
    </div>
  );
}

export default HomePage;
