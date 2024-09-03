import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const JoKenPo2Module = buildModule("JoKenPo2Module", (m) => {
  const joKenPo = m.contract("JoKenPo2");

  return { joKenPo };
});

export default JoKenPo2Module;
