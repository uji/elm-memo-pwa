import { Elm } from './Main.elm';
import './main.css';

const app = Elm.Main.init({
  node: document.getElementById('root')
});

app.ports.saveBackLogItem.subscribe(item => {
  console.log(item);
})
