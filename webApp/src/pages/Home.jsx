import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import Banner from "../images/banner.jpg";
import { About } from "./About.jsx";
import { Services } from "./Services.jsx";
import { Team } from "./Team.jsx";
import { Contact } from "./Contact.jsx";
import Footer from "../components/Layout/Footer.jsx";

export const Home = () => {
  const [activeSection, setActiveSection] = useState('home');

  const scrollToSection = (id) => {
    const section = document.getElementById(id);
    if (section) {
      section.scrollIntoView({ behavior: 'smooth' });
    }
  };

  useEffect(() => {
    const handleScroll = () => {
      const scrollPosition = window.scrollY + window.innerHeight / 2;
      const sections = ['home', 'about-us', 'services', 'team', 'contact'];
      for (const section of sections) {
        const el = document.getElementById(section);
        if (el) {
          const { offsetTop, offsetHeight } = el;
          if (scrollPosition >= offsetTop && scrollPosition <= offsetTop + offsetHeight) {
            setActiveSection(section);
            break;
          }
        }
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => {
      window.removeEventListener('scroll', handleScroll);
    };
  }, []);


  return (
    <>
      <>
        <div className="bg-orange-400 fixed w-full z-10">
          <nav className="flex justify-between">
            <div className="pt-1.5 pl-2"><h1 className="text-3xl">ROADSAFE</h1></div>
            <div>
              <ul className='relative flex flex-col justify-start md:flex-row p-4'>
                <li className={`px-5 text-base ${activeSection === 'home' ? ' text-white' : ''}`}>
                  <button onClick={() => scrollToSection('home')} className="hover:transform hover:scale-110 transition duration-300 ease-in-out"
                  >Home</button>
                </li>
                <li className={`px-5 text-base ${activeSection === 'about-us' ? ' text-white' : ''}`}>
                  <button onClick={() => scrollToSection('about-us')} className="hover:transform hover:scale-110 transition duration-300 ease-in-out"
                  >About</button>
                </li>
                <li className={`px-5 text-base ${activeSection === 'services' ? ' text-white' : ''}`}>
                  <button onClick={(e) => { scrollToSection('services'); }} className="hover:transform hover:scale-110 transition duration-300 ease-in-out"
                  >Services</button>
                </li>
                <li className={`px-5 text-base ${activeSection === 'team' ? ' text-white' : ''}`}>
                  <button onClick={() => scrollToSection('team')} className="hover:transform hover:scale-110 transition duration-300 ease-in-out"
                  >Team</button>
                </li>
                <li className={`px-5 text-base ${activeSection === 'contact' ? ' text-white' : ''}`}>
                  <button onClick={() => scrollToSection('contact')} className="hover:transform hover:scale-110 transition duration-300 ease-in-out"
                  >Contact</button>
                </li>
              </ul>
            </div>
          </nav>

        </div>
        <div id="home"
          className="home"
          style={{
            backgroundImage: `url(${Banner})`,
            backgroundSize: "cover",
            backgroundRepeat: "no-repeat",
            height: "100vh",
            display: "flex",
            justifyContent: "flex-start",
            alignItems: "center",
            padding: "0 20px",
          }}
        >
          <div className="headerContainer p-7 pt-20">
            <h3 className="text-5xl text-white">Welcome to</h3>
            <h1 className="text-5xl text-white font-bold">ROADSAFE</h1>
            <div
              className="buttonContainer"
              style={{
                display: "flex",
                gap: "20px",
                marginTop: "20px",
              }}
            >
              <Link to="/signin">
                <button
                  className="loginButton bg-orange-400 hover:transform hover:scale-110 transition duration-200 ease-in-out"
                  style={{
                    padding: "10px 20px",
                    border: "none",
                    borderRadius: "5px",
                    fontSize: "16px",
                    cursor: "pointer",
                    color: "black",
                    // backgroundColor: "darkorange",
                    transition: "background-color 0.3s ease",
                  }}
                  onMouseOver={(e) => e.target.style.backgroundColor = "#22c55e"}
                  onMouseOut={(e) => e.target.style.backgroundColor = "#fb923c"}
                >
                  Log In
                </button>
              </Link>
              <Link to="/signup">
                <button
                  className="signupButton bg-orange-400 hover:transform hover:scale-110 transition duration-200 ease-in-out"
                  style={{
                    padding: "10px 20px",
                    border: "none",
                    borderRadius: "5px",
                    fontSize: "16px",
                    cursor: "pointer",
                    color: "black",
                    // backgroundColor: "darkorange",
                    transition: "background-color 0.3s ease",
                  }}
                  onMouseOver={(e) => e.target.style.backgroundColor = "#22c55e"}
                  onMouseOut={(e) => e.target.style.backgroundColor = "#fb923c"}
                >
                  Sign Up
                </button>
              </Link>
            </div>
          </div>
        </div>

        <div id="about-us" className="pt-12 border-b-2 border-gray-700">
          <About />
        </div>

        <div id="services" className="p-12 border-b-2 border-gray-700">
          <Services />
        </div>


        <div id="team" className="p-50 border-b-2 border-gray-700">
          <Team />
        </div>

        <div id="contact" className="p-12">
          <Contact />
        </div>

        <Footer />

      </>
    </>
  );
};