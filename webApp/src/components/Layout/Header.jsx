import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import "../../styles/HeaderStyles.css";

const Header = () => {
  const [mobileOpen, setMobileOpen] = useState(false);

  // handle menu click
  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };

  
  // menu drawer
  const drawer = (
    <div onClick={handleDrawerToggle} className="text-center">
      <h1 className="text-black text-2xl my-2">ROADSAFE</h1>
      <hr />
      <ul className="mobile-navigation">
        <li>
          <NavLink activeClassName="active" to={"/"}>
            Home
          </NavLink>
        </li>
        <li>
          <NavLink to={"/about"}>About</NavLink>
        </li>
        <li>
          <NavLink to={"/services"}>Menu</NavLink>
        </li>
        <li>
          <NavLink to={"/team"}>Menu</NavLink>
        </li>
        <li>
          <NavLink to={"/contact"}>Contact</NavLink>
        </li>
      </ul>
    </div>
  );

  return (
    <div>
      <nav className="bg-orange-500 fixed w-full">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center">
              <button
                className="text-white hover:text-black focus:outline-none focus:text-black sm:hidden"
                onClick={handleDrawerToggle}
              >
                <svg
                  className="h-6 w-6"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  aria-hidden="true"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth="2"
                    d="M4 6h16M4 12h16m-7 6h7"
                  />
                </svg>
              </button>
              <div className="hidden sm:block">
                <ul className="flex space-x-4">
                  <li>
                    <NavLink
                      activeClassName="active"
                      to={"/"}
                      className="text-white hover:text-black px-3 py-2 rounded-md text-sm font-medium"
                    >
                      Home
                    </NavLink>
                  </li>
                  <li>
                    <NavLink
                      to={"/about"}
                      className="text-white hover:text-black px-3 py-2 rounded-md text-sm font-medium"
                    >
                      About
                    </NavLink>
                  </li>
                  <li>
                    <NavLink
                      to={"/services"}
                      className="text-white hover:text-black px-3 py-2 rounded-md text-sm font-medium"
                    >
                      Services
                    </NavLink>
                  </li>
                  <li>
                    <NavLink
                      to={"/team"}
                      className="text-white hover:text-black px-3 py-2 rounded-md text-sm font-medium"
                    >
                      Team
                    </NavLink>
                  </li>
                  <li>
                    <NavLink
                      to={"/contact"}
                      className="text-white hover:text-black px-3 py-2 rounded-md text-sm font-medium"
                    >
                      Contact
                    </NavLink>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div className="sm:hidden">{drawer}</div>
      </nav>
      <div>
        <div className="sm:hidden">
          <div className="pt-2 pb-3 space-y-1">{drawer}</div>
        </div>
      </div>
    </div>
  );
};

export default Header;
