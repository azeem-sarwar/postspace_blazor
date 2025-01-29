#!/bin/bash

# Base directory
BASE_DIR="BlazorAtomicApp"
COMPONENTS_DIR="$BASE_DIR/Components"

# Create folder structure
mkdir -p \
  "$COMPONENTS_DIR/Atoms/Button" \
  "$COMPONENTS_DIR/Atoms/Input" \
  "$COMPONENTS_DIR/Molecules/SearchForm" \
  "$COMPONENTS_DIR/Organisms/ProductGrid" \
  "$COMPONENTS_DIR/Templates" \
  "$BASE_DIR/Pages" \
  "$BASE_DIR/Shared" \
  "$BASE_DIR/wwwroot/css"

# Create Atom components
# Button
cat > "$COMPONENTS_DIR/Atoms/Button/Button.razor" << 'EOL'
<button @attributes="AdditionalAttributes" class="btn @CssClass">
    @ChildContent
</button>

@code {
    [Parameter] public string CssClass { get; set; } = "btn-primary";
    [Parameter] public RenderFragment ChildContent { get; set; }
    [Parameter(CaptureUnmatchedValues = true)] 
    public Dictionary<string, object> AdditionalAttributes { get; set; }
}
EOL

cat > "$COMPONENTS_DIR/Atoms/Button/Button.razor.css" << 'EOL'
.btn {
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
}
EOL

# Input
cat > "$COMPONENTS_DIR/Atoms/Input/Input.razor" << 'EOL'
<input @bind-value="Value" 
       @bind-value:event="oninput"
       class="form-control @CssClass"
       placeholder="@Placeholder" />

@code {
    [Parameter] public string Value { get; set; }
    [Parameter] public string Placeholder { get; set; }
    [Parameter] public string CssClass { get; set; }
}
EOL

# Create Molecule component
cat > "$COMPONENTS_DIR/Molecules/SearchForm/SearchForm.razor" << 'EOL'
<EditForm Model="@SearchModel" OnValidSubmit="HandleSearch">
    <Input @bind-Value="SearchModel.Query" 
           Placeholder="Search products..."
           CssClass="search-input" />
    <Button type="submit" CssClass="btn-search">Search</Button>
</EditForm>

@code {
    private SearchModel SearchModel { get; set; } = new();

    [Parameter]
    public EventCallback<string> OnSearch { get; set; }

    private async Task HandleSearch()
    {
        await OnSearch.InvokeAsync(SearchModel.Query);
    }

    public class SearchModel
    {
        public string Query { get; set; }
    }
}
EOL

# Create Organism component
cat > "$COMPONENTS_DIR/Organisms/ProductGrid/ProductGrid.razor" << 'EOL'
@if (Products == null)
{
    <p>Loading products...</p>
}
else
{
    <div class="product-grid">
        @foreach (var product in Products)
        {
            <div class="product-card">
                <h3>@product.Name</h3>
                <p>Price: @product.Price.ToString("C")</p>
                <Button OnClick="() => OnAddToCart.InvokeAsync(product)">
                    Add to Cart
                </Button>
            </div>
        }
    </div>
}

@code {
    [Parameter] public List<Product> Products { get; set; }
    [Parameter] public EventCallback<Product> OnAddToCart { get; set; }
}
EOL

# Create Template
cat > "$COMPONENTS_DIR/Templates/MainLayout.razor" << 'EOL'
@inherits LayoutComponentBase

<div class="main-layout">
    <header class="main-header">
        <h1>@SiteTitle</h1>
        <nav>
            <a href="/">Home</a>
            <a href="/products">Products</a>
        </nav>
    </header>
    
    <main class="content">
        @Body
    </main>
    
    <footer class="main-footer">
        &copy; 2024 Atomic Design Store
    </footer>
</div>

@code {
    [Parameter] public string SiteTitle { get; set; } = "Atomic Commerce";
}
EOL

# Create Page
cat > "$BASE_DIR/Pages/Home.razor" << 'EOL'
@page "/"

<MainLayout SiteTitle="Atomic Design Store">
    <div class="home-page">
        <h2>Welcome to our Store</h2>
        <SearchForm OnSearch="HandleSearch" />
        <ProductGrid Products="products" 
                   OnAddToCart="AddToCartHandler" />
    </div>
</MainLayout>

@code {
    private List<Product> products = new()
    {
        new Product { Id = 1, Name = "Atomic T-Shirt", Price = 29.99m },
        new Product { Id = 2, Name = "Blazor Hoodie", Price = 49.99m }
    };

    private void HandleSearch(string query)
    {
        // Implement search logic
    }

    private void AddToCartHandler(Product product)
    {
        // Implement add to cart logic
    }

    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
    }
}
EOL

# Create global CSS
cat > "$BASE_DIR/wwwroot/css/app.css" << 'EOL'
.product-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 2rem;
    padding: 2rem;
}

.product-card {
    border: 1px solid #ddd;
    padding: 1rem;
    border-radius: 8px;
}

.main-header {
    background: #f8f9fa;
    padding: 1rem;
    border-bottom: 1px solid #dee2e6;
}

.main-footer {
    background: #f8f9fa;
    padding: 1rem;
    text-align: center;
    border-top: 1px solid #dee2e6;
}
EOL

# Create imports file
cat > "$BASE_DIR/_Imports.razor" << 'EOL'
@using Microsoft.AspNetCore.Components.Web
@using System.Collections.Generic
@using Microsoft.AspNetCore.Components.Forms
EOL

echo "Atomic Design Blazor structure created successfully!"
echo "Next steps:"
echo "1. Create a new Blazor WebAssembly project"
echo "2. Copy these files into your project"
echo "3. Add services and data implementations"
echo "4. Run 'dotnet build' and 'dotnet run'"

# Make script executable
chmod +x create-atomic-blazor.sh