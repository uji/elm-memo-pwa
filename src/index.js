import { Elm } from './Main.elm';
import './main.css';

const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: localStorage.getItem('test')
});

app.ports.saveBackLog.subscribe(backlog => {
  localStorage.setItem('test', JSON.stringify(backlog))
  console.log("saved backlog: ", localStorage.getItem('test'));
})

app.ports.readBackLogCmd.subscribe(() => {
  console.log("start read backlog");
})

app.ports.readBackLogSub.send(
  localStorage.getItem('test')
)
