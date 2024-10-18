import React, { useEffect, useState } from 'react';

export const Card = ({ id, email, location, category, description, createdAt, updatedAt, image, statusData, count }) => {
  const [status, setStatus] = useState('Update Status');
  const [updateDate, setUpdateDate] = useState(updatedAt);

  useEffect(() => {
    const updateStatusInBackend = async () => {
      try {
        const response = await fetch('http://127.0.0.1:3000/updateStatus', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            id: id,
            status: status,
          }),
        });

        const data = await response.json();

        console.log("Updated Detail:", data.success.updatedAt);
        setUpdateDate(data.success.updatedAt)
      } catch (error) {
        console.error("Error updating complaint details:", error);
      }
    };

    if (status !== 'Update Status') {
      updateStatusInBackend();
    }
  }, [status, id]);

  const handleStatusChange = (e) => {
    setStatus(e.target.value);
  };


  return (
    <div style={{ padding: 10, display: "flex", flexDirection: "row", justifyContent: "flex-center", border: "2px", borderRadius: "5px", borderBlockColor: "#ffffff" }}>
      <div style={{ padding: 50, paddingLeft: 20, paddingRight: 20, paddingTop: 30, backgroundColor: "white", width: 340, background: "white", alignItems: "center", justifyContent: "center", borderRadius: "7px" }} className="shadow-md">
        <h3 style={{ fontWeight: 'bold', backgroundColor: "#FFBF00", position: 'relative', padding: '10px', borderRadius: '7px' }}>Complaint no. - {count}</h3>
        <br></br>
        <img src={image} type="image" style={{ width: '290px', height: '180px', borderRadius: '7px' }} />
        <br></br>
        <h3>Email: {email}</h3>
        <p>Location: {location}</p>
        <p>Category: {category.join(", ")}</p>
        <p>Description: {description}</p>
        <p>Created At: {new Date(createdAt).toLocaleString()}</p>
        <p>Updated At: {new Date(updateDate).toLocaleString()}</p>
        <div style={{ display: "flex", flexDirection: "row", justifyContent: "flex-center", alignItems: "center", paddingTop: "10px" }}>
          <p style={{ paddingRight: "10px" }}>Status :</p>
          <select value={status} onChange={handleStatusChange} style={{ padding: "5px", borderRadius: "5px", border: "1px solid #ccc" }} className="cursor-pointer">
            {statusData === "Update Status" ? (
              <>
                <option disabled hidden value="Update Status">{statusData}</option>
                <option value="Inprocess">Inprocess</option>
                <option value="Completed">Completed</option>
              </>
            ) : statusData === "Completed" ? (
              <>
                <option value="Completed">{statusData}</option>
                <option value="Inprocess">Inprocess</option>
              </>
            ) : (
              <>
                <option value="Inprocess">Inprocess</option>
                <option value="Completed">Completed</option>
              </>
            )}
          </select>

        </div>
      </div>
    </div>
  );
};
