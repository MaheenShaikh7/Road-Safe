import React, { useRef, useState } from 'react';
import emailjs from '@emailjs/browser';
import { FaEnvelope, FaPhone, FaDownload } from 'react-icons/fa';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

export const Contact = () => {

  const [isBlinking, setIsBlinking] = useState(false);

  const handleClick = (e) => {
    setIsBlinking(true);

    setTimeout(() => {
      setIsBlinking(false);
    }, 500);

  };
  const form = useRef();


  const sendEmail = (e) => {
    e.preventDefault();


    emailjs
      .sendForm('service_fzp6iyb', 'template_21ivsz3', form.current, {
        publicKey: 'JKD5qSwCIPlamW2Yg',
      })
      .then(
        () => {
          toast.success("Message send succeffully")
          setLoading(false)
          e.target.reset();
        },
        (error) => {
          console.log('FAILED...', error.text);
          toast.error('FAILED...', error.text)
        },
      );
  };

  return (
    <>

      <div className="my-5 text-center">
        <h4 className="font-bold mb-2 text-3xl">Contact Us</h4>
      </div>

      <div className="px-4">
        <div className="flex justify-center flex-wrap mx-10 md:mx-20 lg:mx-40">
          <a href={`mailto:luckyvishwa1104@gmail`} className="text-blue-500" target="blank">
            <div className="border border-gray-300 rounded-lg p-4 flex flex-col items-center h-32 w-56 mb-2 hover:transform hover:scale-110 transition duration-300 ease-in-out">
              {/* hover:shadow-lg - on-hovwer shadow effect */}
              <FaEnvelope size={24} className="text-red-500" />
              <h3 className="text-lg mt-2 text-black">Send us email</h3>
              <h4 className="text-sm mt-1 text-black">help@roadsafe.com</h4>
            </div></a>

          <a href="" target="blank">
            <div className="border border-gray-300 rounded-lg p-4 flex flex-col items-center h-32 w-56 mb-2 mr-5 ml-5 hover:transform hover:scale-110 transition duration-300 ease-in-out">
              <FaPhone size={24} className="text-green-500" />
              <h3 className="text-lg mt-2">Call us</h3>
              <h4 className="text-sm mt-1">1800-00-0000</h4>
            </div></a>

          <a href={`mailto:luckyvishwa1104@gmail`} target="blank">
            <div className="border border-gray-300 rounded-lg p-4 flex flex-col items-center h-32 w-56 mb-2 hover:transform hover:scale-110 transition duration-300 ease-in-out">
              <FaDownload size={24} className="text-yellow-500" />
              <h3 className="text-lg mt-2">Get our app</h3>
              <h4 className="text-sm mt-1">Download Now</h4>
            </div></a>
        </div>
      </div>

      <br></br>

      <div className="bg-gray-100 rounded-lg p-6 mx-auto max-w-2xl sm:max-w-3xl lg:max-w-4xl" style={{ maxWidth: 715 }}>
        <form ref={form} onSubmit={sendEmail}>
          <div className="mb-4">
            <label htmlFor="name" className="block text-gray-700 text-sm font-bold mb-2">Name</label>
            <input id="name" type="text" name="to_name" className="border rounded-md px-3 py-2 w-full" />
          </div>
          <div className="mb-4">
            <label htmlFor="email" className="block text-gray-700 text-sm font-bold mb-2">Email</label>
            <input id="email" type="email" name="from_name" className="border rounded-md px-3 py-2 w-full" />
          </div>
          <div className="mb-4">
            <label htmlFor="message" className="block text-gray-700 text-sm font-bold mb-2">Message</label>
            <textarea id="message" name="message" className="border rounded-md px-3 py-2 w-full h-32"></textarea>
          </div>
          <button
            type="submit"
            onClick={handleClick}
            className={`bg-blue-500 hover:transform hover:scale-110 transition duration-300 ease-in-out text-white py-2 px-4 rounded transition-all ${isBlinking ? 'animate-blink bg-blue-500' : 'animate-blink bg-green-500'}`}
          >Send</button>
        </form>
      </div>

      <br></br>

      <div className="flex justify-center items-center flex-col my-3">
        <div className="w-full md:w-3/4 lg:w-2/4">
          <table className="w-full border-collapse border border-black rounded-lg">
            <thead className="bg-orange-400 text-black">
              <tr>
                <th className="py-2">Contact Details</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td className="py-2 flex items-center justify-center">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    className="h-6 w-6 text-red-500 mr-2"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                    />
                  </svg>
                  1800-00-0000 (toll-free)
                </td>
              </tr>
              <tr>
                <td className="py-2 flex items-center justify-center">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    className="h-6 w-6 text-skyblue-500 mr-2"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M3 6l18 12M3 18l18-12"
                    />
                  </svg>
                  help@roadsafe.com
                </td>
              </tr>
              <tr>
                <td className="py-2 flex items-center justify-center">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    className="h-6 w-6 text-green-500 mr-2"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M5 13l4 4L19 7"
                    />
                  </svg>
                  6234517890
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <ToastContainer />
    </>
  );
};
