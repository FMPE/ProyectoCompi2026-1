const API_URL = 'http://localhost:8000';

const fileInput = document.getElementById('fileInput');
const compileBtn = document.getElementById('compileBtn');
const startBtn = document.getElementById('startBtn');
const stepBtn = document.getElementById('stepBtn');
const stopBtn = document.getElementById('stopBtn');
const assemblyCode = document.getElementById('assemblyCode');
const registersList = document.getElementById('registersList');
const stackList = document.getElementById('stackList');

let isDebugging = false;

compileBtn.addEventListener('click', async () => {
    if (!fileInput.files[0]) {
        alert('Please select a file first');
        return;
    }

    const formData = new FormData();
    formData.append('file', fileInput.files[0]);

    try {
        compileBtn.disabled = true;
        compileBtn.textContent = 'Compiling...';
        
        const response = await fetch(`${API_URL}/compile`, {
            method: 'POST',
            body: formData
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || 'Compilation failed');
        }

        assemblyCode.textContent = data.assembly;
        startBtn.disabled = false;
        alert('Compilation successful!');

    } catch (error) {
        alert('Error: ' + error.message);
    } finally {
        compileBtn.disabled = false;
        compileBtn.textContent = 'Compile';
    }
});

startBtn.addEventListener('click', async () => {
    try {
        const response = await fetch(`${API_URL}/debug/start`, { method: 'POST' });
        const data = await response.json();
        
        if (!response.ok) throw new Error(data.error);

        updateState(data);
        setDebugging(true);

    } catch (error) {
        alert('Error starting debugger: ' + error.message);
    }
});

stepBtn.addEventListener('click', async () => {
    try {
        const response = await fetch(`${API_URL}/debug/step`, { method: 'POST' });
        const data = await response.json();
        
        if (!response.ok) throw new Error(data.error);

        updateState(data);

    } catch (error) {
        alert('Error stepping: ' + error.message);
    }
});

stopBtn.addEventListener('click', async () => {
    try {
        await fetch(`${API_URL}/debug/stop`, { method: 'POST' });
        setDebugging(false);
        clearState();
    } catch (error) {
        console.error(error);
    }
});

function setDebugging(active) {
    isDebugging = active;
    startBtn.disabled = active;
    stepBtn.disabled = !active;
    stopBtn.disabled = !active;
    compileBtn.disabled = active;
}

function updateState(data) {
    // Update Registers
    registersList.innerHTML = '';
    if (data.registers) {
        for (const [name, value] of Object.entries(data.registers)) {
            const div = document.createElement('div');
            div.className = 'reg-item';
            div.innerHTML = `<span class="reg-name">${name}</span><span class="reg-val">${value}</span>`;
            registersList.appendChild(div);
        }
    }

    // Update Stack
    stackList.innerHTML = '';
    if (data.stack) {
        data.stack.forEach(item => {
            const div = document.createElement('div');
            div.className = 'stack-item';
            div.innerHTML = `<span class="stack-addr">${item.address}</span><span class="stack-val">${item.value}</span>`;
            stackList.appendChild(div);
        });
    }
}

function clearState() {
    registersList.innerHTML = '';
    stackList.innerHTML = '';
}
