import { useState, useEffect } from 'react';
import Header from './Header';
import { Leaderboard, Options, getResult, play, getLeaderboard } from './Web3Service';

function App() {

  useEffect(() => {
    getLeaderboard().then(leaderboard => setLeaderboard(leaderboard)).catch(err => setMessage(err.message))
  }, [])

  const [message, setMessage] = useState("")
  const [leaderboard, setLeaderboard] = useState<Leaderboard>()

  function onPlay(option: Options) {
    setLeaderboard({ ...leaderboard, result: "Sending your choice..." })
    play(option).then(tx => getResult()).then(result => setLeaderboard({ ...leaderboard, result })).catch(err => setMessage(err.message))
  }

  return (
    <div className='container'>
      <Header></Header>
      <main>
        <div className='py-5 text-center'>
          <h2>Leaderboard</h2>
          <p className='lead'>Check the best players Score and play the game</p>
          <p className='lead text-danger'>{message}</p>
        </div>
        <div className='col-md-8 col-lg-12'>
          <div className='row'>
            <div className='col-sm-6'>
              <h4 className='mb-3'>Best Players</h4>
              <div className='card card-body mb-5 border-0 shadow'>
                <table className='table table-hover'>
                  <thead>
                    <tr>
                      <th className='border-gray-200'>Player</th>
                      <th className='border-gray-200'>Wins</th>
                    </tr>
                  </thead>
                  <tbody>
                    {
                      leaderboard && leaderboard.players && leaderboard.players.length
                        ? leaderboard.players.map(p => (
                          <tr key={p.wallet}>
                            <td>{p.wallet}</td>
                            <td>{p.wins}</td>
                          </tr>))
                        :
                        <tr>
                          <td colSpan={2}>Loading... </td>
                        </tr>
                    }
                  </tbody>
                </table>
              </div>
            </div>
            <div className='col-sm-6'>
              <h4 className='mb-3'>Games</h4>
              <div className='card card-body mb-5 border-0 shadow'>
                <h5 className='mb-3 text-primary'>Current Status: </h5>
                <div className='alert alert-success'>{
                  leaderboard && leaderboard.result ? leaderboard.result : "Loading..."
                }</div>
                <h5 className='mb-3 text-primary'>{
                  leaderboard && leaderboard.result?.indexOf("won") !== -1 || !leaderboard?.result
                    ? "Start a new game"
                    : "Play this game"
                }</h5>
                <div className='d-flex'>
                  <div className='col-sm-4' onClick={() => onPlay(Options.ROCK)} >
                    <div className='alert alert-info me-3'>
                      <h2>Rock</h2>
                    </div>
                  </div>
                  <div className='col-sm-4' onClick={() => onPlay(Options.PAPER)}>
                    <div className='alert alert-info '>
                      <h2>Paper</h2>
                    </div>
                  </div>
                  <div className='col-sm-4' onClick={() => onPlay(Options.SCISSORS)}>
                    <div className='alert alert-info ms-2'>
                      <h2>Scissors</h2>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

export default App;
