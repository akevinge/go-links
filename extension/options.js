// Saves options to chrome.storage
const saveOptions = () => {
    const linkServerURL = document.getElementById('link-server').value;

    chrome.storage.local.set({ linkServerURL }, () => {
        // Update status to let user know options were saved.
        const status = document.getElementById('status');
        status.textContent = 'Options saved.';
        setTimeout(() => {
            status.textContent = '';
        }, 750);
    });
};

// Restores select box and checkbox state using the preferences
// stored in chrome.storage.
const restoreOptions = () => {
    chrome.storage.local.get(
        { linkServerURL: 'http://localhost:5000/go' },
        (items) => {
            document.getElementById('link-server').value = items.linkServerURL;
        },
    );
};

document.addEventListener('DOMContentLoaded', restoreOptions);
document.getElementById('save').addEventListener('click', saveOptions);
