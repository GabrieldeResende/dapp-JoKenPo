import { doLogout, doLogin } from "./Web3Service"
import { useNavigate } from "react-router-dom"
import { useEffect } from "react"


function Header() {

    const navigate = useNavigate()

    // useEffect(() => {
    //     if(localStorage.getItem("account") !== null) {
    //         if(localStorage.getItem("isAdmin") === "true") {
    //             doLogin().then(result => {
    //                 if(!result.isAdmin) {
    //                     localStorage.setItem("isAdmin", "false")
    //                     navigate("app")
    //                 }
    //             }).catch(err => {
    //                 console.error(err)
    //                 onLogoutClick()
    //             })
    //         } else {
    //             navigate("app")
    //         }
    //     } else {
    //         navigate("/")
    //     }
    // }, [])

    function onLogoutClick() {
        doLogout()
        navigate("/")
    }

    return (
        <header className="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom">
            <a href="/app" className="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-body-emphasis text-decoration-none text-light">
                <span className="fs-4">Dapp JoKenPo</span>
            </a>

            <div className="col-md-3 text-end">
                <button onClick={onLogoutClick} type="button" className="btn btn-outline-danger me-2">LogOut</button>
            </div>
        </header>
    )
}

export default Header