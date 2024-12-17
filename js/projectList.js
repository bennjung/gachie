document.addEventListener('DOMContentLoaded', function() {
    const buttons = document.querySelectorAll('.type-btn');
    const projectCards = document.querySelectorAll('.project-card');
    const searchInput = document.getElementById('searchInput');

    // Event listeners for type filter buttons
    buttons.forEach(button => {
        button.addEventListener('click', handleFilterByType);
    });

    // Event listener for the search input
    searchInput.addEventListener('input', handleSearch);

    function handleFilterByType() {
        // Remove 'active' class from all buttons
        buttons.forEach(button => {
            button.classList.remove('active');
        });

        // Add 'active' class to the clicked button
        this.classList.add('active');

        // Trigger the filter function for both type and search
        filterProjects();
    }

    function handleSearch() {
        // Trigger the filter function for both type and search
        filterProjects();
    }

    function filterProjects() {
        const searchTerm = searchInput.value.toLowerCase();
        const selectedType = document.querySelector('.type-btn.active').dataset.type;

        projectCards.forEach(card => {
            const cardType = card.getAttribute('data-type');
            const cardTitle = card.querySelector('h3').textContent.toLowerCase();
            const cardDescription = card.querySelector('.description').textContent.toLowerCase();

            let shouldDisplay = false;

            // Apply both type and search filters
            if (selectedType === 'all' && (cardTitle.includes(searchTerm) || cardDescription.includes(searchTerm))) {
                shouldDisplay = true;
            } else if (cardType === selectedType && (cardTitle.includes(searchTerm) || cardDescription.includes(searchTerm))) {
                shouldDisplay = true;
            }

            // Show or hide the project card based on filtering logic
            card.style.display = shouldDisplay ? 'block' : 'none';
        });
    }
});
