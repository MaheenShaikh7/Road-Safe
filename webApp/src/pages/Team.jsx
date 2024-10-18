import React from "react";
import img1 from "../images/man.png";
import img2 from "../images/woman.png";
import { FaEnvelope, FaLinkedin } from 'react-icons/fa';


export const Team = () => {
  const teamMembers = [
    { src: img1, name: 'Lucky Vishwakarma', email: 'luckyvishwa1104@gmail', linkedin: 'https://www.linkedin.com/in/lucky-vishwakarma-5194ab228' },
    { src: img2, name: 'Amruta Pradhan', email: 'luckyvishwa1104@gmail', linkedin: 'https://www.linkedin.com/in/lucky-vishwakarma-5194ab228' },
    { src: img2, name: 'Maheen Shaikh', email: 'luckyvishwa1104@gmail', linkedin: 'https://www.linkedin.com/in/lucky-vishwakarma-5194ab228' },
    { src: img1, name: 'Ashutosh Gaware', email: 'luckyvishwa1104@gmail', linkedin: 'https://www.linkedin.com/in/lucky-vishwakarma-5194ab228' }
  ];

  return (
    <div className="pt-12">
      <div className="my-15 text-center">
        <h4 className="font-bold my-2 text-2xl md:text-3xl">Our Team</h4>

        <div className="flex justify-center flex-wrap mx-10 md:mx-20 lg:mx-40">
          {teamMembers.map((member, index) => (
            <div key={index} className="flex flex-col items-center m-5">
              <img
                src={member.src}
                alt={member.name}
                className="w-40 h-40 rounded-lg"
              />
              <div className="text-lg mt-3">{member.name}</div>
              <div className="flex mt-5 space-x-4 ">
                <a href={`mailto:${member.email}`} className="text-blue-500" target="blank" >
                  <FaEnvelope className="text-red-500 text-4xl cursor-pointer hover:transform hover:scale-110 transition duration-300 ease-in-out" />
                </a>
                <a href={`${member.linkedin}`} className="text-blue-500" target="blank">
                  <FaLinkedin className="text-blue-600 text-4xl cursor-pointer hover:transform hover:scale-110 transition duration-300 ease-in-out" />
                </a>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

