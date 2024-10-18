import React, { useState, useEffect } from "react";
import Registered from "../images/Registered.png";
import Resolved from "../images/Resolved.png";
import Inprogress from "../images/Inprogress.png";
import Cancelled from "../images/Cancelled.png";
import axios from "axios";

export const About = () => {
  const [successData, setSuccessData] = useState([]);

  const teamMembers = [
    { src: Registered, number: successData[0], name: 'Registered' },
    { src: Resolved, number: successData[1], name: 'Resolved' },
    { src: Inprogress, number: successData[2], name: 'Inprogress' },
    { src: Cancelled, number: '2', name: 'Cancelled' }
  ];

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.post("http://127.0.0.1:3000/getComplaintDetails");
        if (response.data.status) {
          setSuccessData(response.data.allCount);
          console.log(successData);
        }
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, []);

  return (
    <div className="my-15 text-center">
      <h4 className="font-bold my-2 text-2xl md:text-3xl">Team Statistics</h4>

      <div className="flex justify-center flex-wrap mx-10 md:mx-20 lg:mx-40">
        {teamMembers.map((member, index) => (
          <div key={index} className="flex flex-col items-center m-10">
            <img
              src={member.src}
              alt={member.name}
              className="w-40 md:w-48 rounded-lg"
            />
            <div className="text-2xl font-bold mt-3">{member.number}</div>
            <div className="text-lg mt-1">{member.name}</div>
          </div>
        ))}
      </div>

    </div>
  );
};
