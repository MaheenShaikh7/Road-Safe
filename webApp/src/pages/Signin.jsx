import { useState } from "react"
import { BottomWarning } from "../components/BottomWarning"
import { Button } from "../components/Button"
import { Heading } from "../components/Heading"
import { InputBox } from "../components/InputBox"
import SubHeading from "../components/SubHeading"
import axios from "axios"
import { useNavigate } from "react-router-dom"
import Banner from "../images/banner.jpg";

export const Signin = () => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    const handleLogin = async () => {
        if (password.length < 3) {
            alert("Please enter correct credentials!");
        } else {
            setLoading(true); // Set loading to true when login starts
            try { // https://road-backend.vercel.app/login - for remote server
                const response = await axios.post("http://127.0.0.1:3000/login", {
                    email: username,
                    password: password
                });
                console.log(response)
                localStorage.setItem("token", response.data.token);
                navigate("/dashboard");
            } catch (error) {
                console.error("Error occurred during login:", error);
                alert("Error occurred during login. Please try again.");
            } finally {
                setLoading(false);
            }
        }
    };

    return (
        <div className="flex justify-center bg-gray-900 h-screen bg-cover bg-no-repeat" style={{ backgroundImage: `url(${Banner})` }}>

            <div className="bg-orange-400 fixed w-full z-10">
                <nav className="flex justify-between">
                    <div className="pt-1.5 pl-2">
                        <h1 className="text-3xl">ROADSAFE</h1>
                    </div>
                    <div className="p-4 hover:transform hover:scale-110 transition duration-300 ease-in-out">
                        <a href="/" className="text-black">Home</a>
                    </div>
                </nav>
            </div>

            <div className="flex justify-center flex-col">
                <div className="rounded-lg bg-white w-80 text-center p-2 h-max px-4">
                    <Heading label={"Sign in"} />
                    <SubHeading label={"Enter your credentials to access your account"} />
                    <InputBox onChange={(e) => {
                        setUsername(e.target.value)
                    }} label={"Email"} placeholder={"email@gmail.com"} />
                    <InputBox onChange={(e) => {
                        setPassword(e.target.value)
                    }} label={"Password"} placeholder={"pasword"} />
                    <div className="pt-3">
                        <Button onClick={handleLogin} label={loading ? "Signing in..." : "Sign in"} />
                        <BottomWarning label={"Don't have an account?"} buttonText={"Sign up"} to={"/signup"} />
                    </div>
                </div>
            </div>
        </div>
    );
};