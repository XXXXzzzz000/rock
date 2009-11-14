import io/File
import structs/[HashMap, ArrayList]
import ../frontend/[Token, SourceReader]
import Node, FunctionDecl, Visitor, Import, Include, Use, TypeDecl
import tinker/[Response, Resolver, Trail]

Module: class extends Node {

    fullName, simpleName, packageName, pathElement = "" : String
    
    types     := HashMap<TypeDecl> new()
    functions := HashMap<FunctionDecl> new()
    
    includes := ArrayList<Include> new()
    imports  := ArrayList<Import> new()
    uses     := ArrayList<Use> new()

    init: func ~module (.fullName, .token) {
        super(token)
        this fullName = fullName replace(File separator, '/')
        idx := fullName lastIndexOf('/')
        
        match idx {
            case -1 =>
                simpleName = fullName clone()
                packageName = ""
            case =>
                simpleName = fullName substring(idx + 1)
                packageName = fullName substring(0, idx)
        }
    }
    
    addFunction: func (fDecl: FunctionDecl) {
        functions add(fDecl name, fDecl)
    }
    
    addType: func (tDecl: TypeDecl) {
        types add(tDecl name, tDecl)
    }
    
    accept: func (visitor: Visitor) { visitor visitModule(this) }
    
    getOutPath: func (suffix: String) -> String {
        pathElement + File separator + fullName + suffix
    }
    
    resolve: func (trail: Trail, res: Resolver) -> Response {
        
        trail push(this)
        
        for(tDecl in types) {
            if(tDecl isResolved()) continue
            response := tDecl resolve(trail, res)
            if(!response ok()) return response
        }
        
        trail pop(this)
        
        return Responses OK
    }

}
