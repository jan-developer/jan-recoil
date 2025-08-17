window.addEventListener('message', (event) => {
    const menu = document.getElementById('recoilMenu');

    if(event.data.action === 'toggle') {
        if(event.data.open) {
            menu.style.display = 'block';
            setTimeout(() => { menu.classList.add('show'); }, 20); 
            document.getElementById('recoilSlider').value = event.data.recoil;
            document.getElementById('recoilValue').innerText = event.data.recoil;
            document.getElementById('weaponName').innerText = 'Weapon: ' + (event.data.weapon ? event.data.weapon : 'Unknown');
        } else {
            menu.classList.remove('show');
            setTimeout(() => { menu.style.display = 'none'; }, 400); 
        }
    } else if(event.data.action === 'update') {
        document.getElementById('recoilSlider').value = event.data.recoil;
        document.getElementById('recoilValue').innerText = event.data.recoil;
    }
});

const slider = document.getElementById('recoilSlider');
const value = document.getElementById('recoilValue');

slider.addEventListener('input', () => {
    value.innerText = slider.value;
    fetch(`https://${GetParentResourceName()}/setRecoil`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({recoil: slider.value})
    });
});

document.getElementById('saveBtn').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/saveRecoil`, { method: 'POST' });
});

document.getElementById('resetBtn').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/resetRecoil`, { method: 'POST' });
});

document.getElementById('closeBtn').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/closeUI`, { method: 'POST' });
});
