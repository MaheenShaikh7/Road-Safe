import React from "react";
import { AiFillInstagram, AiFillTwitterSquare, AiFillGithub, AiFillYoutube, AiFillLinkedin } from "react-icons/ai";

export const Footer = () => {
  return (
    <div className="text-center bg-orange-400 p-8 flex flex-col md:flex-row items-center justify-between">
      <div className="my-3 flex items-center flex-col md:flex-row">

        <div className="mb-2 md:mb-0 text-left">
          <h1 className="mb-2 ml-1 text-lg">Our Social Networks</h1>
          <div className="flex flex-wrap gap-2">

            <a href="https://www.linkedin.com/login" target="blank">
            <AiFillLinkedin className="text-white text-4xl hover:transform hover:scale-110 transition duration-300 ease-in-out" /></a>

            <a href="https://twitter.com/i/flow/login" target="blank">
            <AiFillTwitterSquare className="text-white text-4xl hover:transform hover:scale-110 transition duration-300 ease-in-out " /></a>

            <a href="https://www.instagram.com/accounts/login/?hl=en" target="blank">
            <AiFillInstagram className="text-white text-4xl hover:transform hover:scale-110 transition duration-300 ease-in-out" /></a>

            <a href="https://github.com/login" target="blank">
            <AiFillGithub className="text-white text-4xl hover:transform hover:scale-110 transition duration-300 ease-in-out" /></a>

            <a href="https://www.youtube.com" target="blank">
            <AiFillYoutube className="text-white text-4xl hover:transform hover:scale-110 transition duration-300 ease-in-out" /></a>
          </div>
        </div>

      </div>

      <div className="text-left">
        
        <h3><span className="font-bold">Call</span> - 1800-00-0000</h3>
        <h3><span className="font-bold">App</span> - Download Now</h3>
        <h3><span className="font-bold">Mail</span> - help@roadsafe.com</h3>
      </div>
    </div>

  );
};

export default Footer;
