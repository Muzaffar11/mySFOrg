public with sharing class XmlBuild {
    private string xml;
    private string indent = '';
    private List<string> stack = new List<string>();
	
    public XmlBuild(string doctype) { 
    	this.xml = doctype + '\n';
    }
    
    public void Indent() {
	    for (integer i = 0; i < this.stack.size(); i++) {
	    	this.xml += this.indent;
	    }
    }
   
    /* sometimes it's necessary to send additional info to worldpay using cdata */ 
    public void cdata_open(string element, string cdata) {
	    this.Indent();
	    this.xml += '<![CDATA[' + cdata + ']]>'+'\n';
    }
    
    //Used when an element has sub-elements
    // This function adds an open tag to the output
    public void Push(string element, Map<string, string> attributes) {
		this.Indent();
		this.xml += '<'+element;
		if(attributes != null) {
			for(string key : attributes.KeySet()) {
				string value = attributes.get(key);
				if(!string.IsEmpty(value))
					this.xml += ' '+key+'="'+value.escapeHtml4()+'"';
			}
		}		
		this.xml += '>\n';
		this.stack.add(element);
	}
	
	public void Push(string element) {
		this.Push(element, null);
	}

    //Used when an element has no subelements.
    //Data within the open and close tags are provided with the 
    //contents variable
    public void Element(string element, string content, Map<string, string> attributes) {
		this.Indent();
		this.xml += '<'+element;
		if(attributes != null) {
			for(string key : attributes.KeySet()) {
				string value = attributes.get(key);
				this.xml += ' '+key+'="'+value.escapeHtml4()+'"';
			}
		}
		this.xml += '>'+content.escapeHtml4()+'</'+element+'>'+'\n';
	}
	
	public void Element(string element, string content) {
		this.Element(element, content, null);
	}

    public void  EmptyElement(string element, Map<string, string> attributes) {
		this.Indent();
		this.xml += '<'+element;
		if(attributes != null) {
			for(string key : attributes.KeySet()) {
				string value = attributes.get(key);
				this.xml += ' '+key+'="'+value.escapeHtml4()+'"';
			}
		}
		this.xml += ' />\n';
	}
	
	public void  EmptyElement(string element) {
		this.EmptyElement(element, null);
	}
	
	//Used to close an open tag
	public void  Pop(string pop_element) {
		string element = this.stack.Remove(this.stack.size()-1);
		this.Indent();
		if(element != pop_element) {
			//throw new CustomException('XML Error: Tag Mismatch when trying to close "'+ pop_element+'" (Last element: '+element+')');
		} else {
			this.xml += '</'+element+'>\n';
		}
	}
	
	public string GetXML() {
        if( this.stack.size() != 0){
            system.debug(' :: this.stack'+ this.stack);
			//throw new CustomException('XML Error: No matching closing tag found for " '+ this.stack[this.stack.size()-1]+'"');
			return null;
            }
        else
        {
            system.debug(' :: this.stack 1'+ this.stack);
            return this.xml;
            
        }
			
	}
}