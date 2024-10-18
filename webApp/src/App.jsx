import {BrowserRouter,Routes,Route} from 'react-router-dom'
import {Signup} from './pages/Signup'
import {Signin} from './pages/Signin'
import {Dashboard} from './pages/Dashboard'
import { Home } from './pages/Home'
import { About } from './pages/About'
import { Services } from './pages/Services'
import { Team } from './pages/Team'
import { Contact } from './pages/Contact'

function App() {
// new comments added
  return (
    <>
        <BrowserRouter>
          <Routes>
            <Route path='home' element={<Home/>}/>
            <Route path="/signup" element={<Signup/>}/>
            <Route path="/signin" element={<Signin/>}/>
            <Route path="/" element={<Home/>}/>
            <Route path="/dashboard" element={<Dashboard/>}/>
            <Route path="/about" element={<About/>}/>
            <Route path="/services" element={<Services/>}/>
            <Route path="/team" element={<Team/>}/>
            <Route path='/contact' element={<Contact/>}/>
            
          </Routes>
        </BrowserRouter>
    </>
  )
}

export default App
