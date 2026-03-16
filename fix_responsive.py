import os

def make_responsive(filepath):
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Common Grid Layout fix
    grid_block = """        .page.active.grid-layout {
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 1.5rem;
            padding: 1.5rem;
        }"""
    
    responsive_css = """
        @media (max-width: 1100px) {
            .page.active.grid-layout { grid-template-columns: 1fr !important; }
            .sidebar, .control-panel, aside { position: static !important; width: 100% !important; order: 2; }
            header { padding: 1rem !important; flex-direction: column !important; gap: 1rem !important; text-align: center; }
            nav { flex-wrap: wrap !important; justify-content: center !important; gap: 0.5rem !important; }
            .diagram-area, .simulation-canvas { overflow-x: auto !important; justify-content: flex-start !important; padding: 40px 10px !important; }
            .gateway-container, .zone, .nodes-container, .shared-volume { min-width: 800px !important; }
        }
    """
    
    if grid_block in content:
        new_content = content.replace(grid_block, grid_block + responsive_css)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False

files = [
    r"c:\Users\Paulo\OneDrive\Documentos\Treinamento HA\visaogeral.html",
    r"c:\Users\Paulo\OneDrive\Documentos\Treinamento HA\glusterfs.html",
    r"c:\Users\Paulo\OneDrive\Documentos\Treinamento HA\Treinamento_Final_HA.html"
]

for f in files:
    success = make_responsive(f)
    print(f"File {f}: {'Success' if success else 'Failed (Block not found)'}")
