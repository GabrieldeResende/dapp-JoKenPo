import { useState, useEffect } from "react"
import { useNavigate } from "react-router-dom";
import { doLogin } from "./Web3Service";

function Login() {

  const navigate = useNavigate()

  const [message, setMessage] = useState("")

  useEffect(() => {
    if (localStorage.getItem("account") !== null) {
      redirectAfterLogin(localStorage.getItem("isAdmin") === "true")
    }
  }, [])

  function redirectAfterLogin(isAdmin: boolean) {
    if (isAdmin)
      navigate("/admin")
    else
      navigate("/app")
  }

  function onBtnClick() {
    setMessage("Loggin in...")
    doLogin().then(result => redirectAfterLogin(result.isAdmin)).catch(err => setMessage(err.message))
  }

  function navigateToApp() {
    navigate("/app")
  }
  function navigateToAdmin() {
    navigate("/admin")
  }


  return (
    <div className="cover-container d-flex w-100 h-100 p-3 mx-auto flex-column">
      <header className="mb-auto">
        <div>
          <h3 className="float-md-start mb-0">Dapp JoKenPo</h3>
          <nav className="nav nav-masthead justify-content-center float-md-end">
            <a onClick={navigateToApp} className="nav-link" href="#">App</a>
            <a onClick={navigateToAdmin} className="nav-link" href="#">Admin</a>
          </nav>
        </div>
      </header>

      <main className="px-3">
        <h1>Login and play with us</h1>
        <p className="lead">Play Rock-Paper-Scissors and earn prizes</p>
        <p className="lead">
          <a href="#" onClick={onBtnClick} className="btn btn-lg btn-secondary fw-bold border-white bg-white text-black-50">
            <img src="/assets/metamask.png" alt="MetaMask logo" width={48} />
            Login with Metamask
          </a>
        </p>
        <div style={{ display: "inline-flex" }}>
        </div>
      </main>

      <footer className="mt-auto text-white-50">
        <p>Built by Gabriel Resende</p>
      </footer>
    </div>
  );
}

export default Login;
